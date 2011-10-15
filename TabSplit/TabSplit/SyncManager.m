//
//  SyncManager.m
//  TabSplit
//
//  Created by Herbert Poul on 10/11/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "SyncManager.h"
#import "SyncDelegate.h"

#import "ASIHTTPRequest.h"

#import "AppDelegate.h"
#import "Currency.h"
#import "Contact.h"

@implementation SyncManager

+ (SyncManager *)getInstance {
    static SyncManager *manager;
    
    if (manager == nil) {
        @synchronized (self) {
            manager = [[SyncManager alloc] init];
            assert(manager != nil);
        }
    }
    return manager;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        // TODO implement me :)
        listeners = [NSMutableArray array];
        _parser = [[SBJsonParser alloc] init];
        managedObjectContext = [AppDelegate managedObjectContext];
        
        syncinprogress = NO;
    }
    return self;
}

- (void) registerListener:(id) delegate {
    [listeners addObject:delegate];
}
- (void) unregisterListener:(id) delegate {
    [listeners removeObject:delegate];
}

- (void) requestJSON:(NSString *)path tag:(RequestTag) tag {
    NSString* url = [NSString stringWithFormat:@"http://tabsplit.net%@", path];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setTag:tag];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void) verifyLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults stringForKey:@"username"];
    NSString *token = [defaults stringForKey: @"token"];
    
    NSString *url = [NSString stringWithFormat:@"/mobile/auth/?username=%@&token=%@", [username stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding], [token stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding ]];
    
    [self requestJSON:url tag:RequestLogin];
}


- (void) syncCurrencies {
    [self requestJSON:@"/mobile/currency/" tag:SyncCurrency];
}

- (void) handleCurrencyResponse:(id) obj {
    NSArray *currencyList = [obj objectForKey:@"currency_list"];
    NSError *error = nil;
    for (id currencyJson in currencyList) {
        NSNumber *serverId = [currencyJson objectForKey:@"id"];
        Currency *c = [Currency fetchCurrencyByServerId:serverId];
        NSLog(@"Fetched currency - %@", c);
        
        if (c == nil) {
            c = (Currency *)[NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:managedObjectContext ];
            NSLog(@"Currency not found. Creating it.");
            [c setServerId:serverId];
        }
        [c setSymbol:[currencyJson objectForKey:@"symbol"]];
        [c setIsocode:[currencyJson objectForKey:@"isocode"]];
        [c setLabel:[currencyJson objectForKey:@"label"]];
        [c setUpdated:[NSDate dateWithTimeIntervalSince1970:[[currencyJson objectForKey:@"symbol"] intValue] * 1000]];
        NSLog(@"date: %@", c.updated);
    }
    
    [managedObjectContext save:&error];
}


- (void) syncContacts {
    [self requestJSON:@"/mobile/friend/" tag:SyncContacts];
}
- (void) handleContactsResponse:(id) obj {
    NSArray *friendList = [obj objectForKey:@"friend_list"];
    NSError *error = nil;
    for (id contactJson in friendList) {
        NSNumber *serverId = [contactJson objectForKey:@"id"];
        Contact *c = [Contact fetchContactByServerId:serverId];
        if (c == nil) {
            c = (Contact *)[NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:managedObjectContext ];
            NSLog(@"Contact not found. Creating it.");
            [c setServerId:serverId];
        }
        [c setUserName:[contactJson objectForKey:@"username"]];
        [c setEmail:[contactJson objectForKey:@"email"]];
        [c setIsmyself:[contactJson objectForKey:@"ismyself"]];
        [c setFullName:[contactJson objectForKey:@"full_name"]];
        [c setAvatarUrl:[contactJson objectForKey:@"avatar"]];
    }
    [managedObjectContext save:&error];
}


- (void) forceSync {
    if (syncinprogress) {
        NSLog(@"forcing sync ignored - sync already in progress!");
        return;
    }
    // start by logging ..
    syncinprogress = YES;
    [self verifyLogin];
}

- (void) fireLoginResult:(BOOL) successful {
    for (id listener in listeners) {
        [listener loginResult:successful];
    }
}
- (void) fireCurrenciesSynced {
    for (id listener in listeners) {
        [listener currenciesSynced];
    }
}
- (void) fireContactsSynced {
    for (id listener in listeners) {
        [listener contactsSynced];
    }
}




- (NSString *)getUsername {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults stringForKey:@"username"];
    return username;
}




- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
        
    NSLog(@"SyncManager: request finished: %@ -- tag: %d", responseString, request.tag);
    id obj = [_parser objectWithString:responseString];
    
    if (request.tag == RequestLogin) {
        NSString *result = [obj objectForKey:@"result"];
        if ([result isEqualToString:@"success"]) {
            [self fireLoginResult:TRUE];
            if (syncinprogress) {
                [self syncCurrencies];
            }
        }
        
        NSLog(@"parsed obj: %@ / result: %@", obj, result);
    } else if (request.tag == SyncCurrency) {
        NSLog(@"Got currencies ...");
        [self handleCurrencyResponse: obj];
        [self fireCurrenciesSynced];
        if (syncinprogress) {
            [self syncContacts];
        }
    } else if (request.tag == SyncContacts) {
        [self handleContactsResponse: obj];
        [self fireContactsSynced];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Handle error!!!! %@", error);
}

@end

