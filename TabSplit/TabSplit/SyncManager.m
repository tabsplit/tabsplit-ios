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
#import "Bill.h"
#import "BillItem.h"
#import "BillItemContact.h"
#import "Currency.h"
#import "Contact.h"
#import "ContactDebt.h"
#import "Transaction.h"
#import "TransactionContact.h"
#import "TransactionDebt.h"
#import "ModelUtils.h"

#import "NSDictionary+NSDictionary_ObjectForKeyReturnNil.h"

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
        Currency *c = [ModelUtils fetchCurrencyByServerId:serverId];
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
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving after syncing currencies - %@", error);
    }
}


- (void) syncContacts {
    [self requestJSON:@"/mobile/friend/" tag:SyncContacts];
}


- (void) handleContactsResponse:(id) obj {
    NSArray *friendList = [obj objectForKey:@"friend_list"];
    NSError *error = nil;
    for (id contactJson in friendList) {
        NSNumber *serverId = [contactJson objectForKey:@"id"];
        Contact *c = [ModelUtils fetchContactByServerId:serverId];
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
        [c setAvatarLargeUrl:[contactJson objectForKey:@"avatar_large"]];
        
        // create all contact debts from scratch ..
        //[c removeContactDebts:[c contactDebts]];
        for (ContactDebt *cd in c.contactDebts) {
            [managedObjectContext deleteObject:cd];
        }
//        c.contactDebts = [NSSet set];
        NSMutableSet *tmp = [c mutableSetValueForKey:@"contactDebts"];
        [tmp removeAllObjects];
//        if (![managedObjectContext save:&error]) {
//            NSLog(@"AAAError while saving after syncing contacts - %@", error);
//        }
        NSArray *debts = (NSArray *)[contactJson objectForKey:@"debts"];
        for (id debt in debts) {
            ContactDebt *cb = (ContactDebt *)[NSEntityDescription insertNewObjectForEntityForName:@"ContactDebt" inManagedObjectContext:managedObjectContext];
            cb.currency = [ModelUtils fetchCurrencyByServerId:[debt objectForKey:@"currency_id"]];
            cb.amount = [debt objectForKey:@"amount"];
            cb.contact = c;
        }
//        if (![managedObjectContext save:&error]) {
//            NSLog(@"BBBError while saving after syncing contacts - %@", error);
//        }
    }
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving after syncing contacts - %@", error);
    }
}

- (void) syncTransactions:(int)page {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int lastsync = [defaults integerForKey:@"lastsync"];
    lastsync = 0;
    if (page == 1) {
        self->sync_lastsync = lastsync;
    }
    

    [self requestJSON:[NSString stringWithFormat:@"/mobile/transaction/?page=%d&after=%d", page, lastsync] tag:SyncTransactions];
}

- (BOOL) handleTransactionsResponse:(id) obj {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int lastsync = self->sync_lastsync;
    int numPages = [[obj objectForKey:@"num_pages"] integerValue];
    int page = [[obj objectForKey:@"page"] integerValue];
    
    NSArray *transactions = [obj objectForKey:@"transactions"];
    NSMutableArray *allTransactions = [NSMutableArray array];
    for (id transactionJson in transactions) {
        NSNumber* serverId = [transactionJson objectForKey:@"id"];
        Transaction *t = [ModelUtils fetchTransactionByServerId:serverId];
        int modifydate = [[transactionJson objectForKey:@"modifydate"] integerValue];
        if (modifydate > lastsync) {
            lastsync = modifydate;
        }
        
        if (t == nil) {
            t = (Transaction *)[NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:managedObjectContext ];
            NSLog(@"Transaction not found. Creating it.");
            [t setServerId:serverId];
        } else {
            if ([t.modifydate integerValue] >= modifydate) {
                NSLog(@"Transaction not modified, no need to sync.");
                continue;
            }
        }
        [allTransactions addObject:t];
        
        NSString *type = [transactionJson objectForKey:@"type"];
        [t setModifydate:[NSNumber numberWithInt:modifydate]];
        [t setDescr:[transactionJson objectForKey:@"description"]];
        [t setDate:[NSDate dateWithTimeIntervalSince1970:[[transactionJson objectForKey:@"date"] doubleValue]]];
        [t setType:type];
        [t setCurrency:[ModelUtils fetchCurrencyByServerId:[transactionJson objectForKey:@"currency"]]];
        [t setSyncstatus:SYNCSTATUS_NOTMODIFIED];
        [t setSyncstatuslastchange:[NSDate date]];
        [t setStatus:[transactionJson objectForKey:@"status"]];

        // Synchronizing contacts ..
        //t.contacts = [NSSet set];
        for (TransactionContact *tc in t.contacts) {
            [managedObjectContext deleteObject:tc];
        }
        [[t mutableSetValueForKey:@"contacts"] removeAllObjects];
        NSArray *contactsJson = [transactionJson objectForKey:@"contacts"];
        for (id contactJson in contactsJson) {
            TransactionContact *tc = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionContact" inManagedObjectContext:managedObjectContext];
            tc.participantType = [contactJson objectForKey:@"participanttype"];
            tc.payAmount = [contactJson objectForKey:@"pay_amount"];
            tc.effectiveAmount = [contactJson objectForKey:@"effective_amount"];
            tc.tipntaxsplit = [contactJson objectForKey:@"tipntaxsplit"];
            tc.contact = [ModelUtils fetchContactByServerId:[contactJson objectForKey:@"user"]];
            tc.transaction = t;
            //NSLog(@"adding transactioncontact - contact: %@", tc.contact);
            //[t addContactsObject:tc];
        }
        
        //t.debts = [NSSet set];
        for (TransactionDebt *tmp in t.debts) {
            [managedObjectContext deleteObject:tmp];
        }
        [[t mutableSetValueForKey:@"debts"] removeAllObjects];

        NSArray *debtsJson = [transactionJson objectForKey:@"debts"];
        for (id debtJson in debtsJson) {
            TransactionDebt *debt = [NSEntityDescription insertNewObjectForEntityForName:@"TransactionDebt" inManagedObjectContext:managedObjectContext];
            debt.contacta = [ModelUtils fetchContactByServerId:[debtJson objectForKey:@"usera"]];
            debt.contactb = [ModelUtils fetchContactByServerId:[debtJson objectForKey:@"userb"]];
            debt.debtamount = [debtJson objectForKey:@"amount"];
            [t addDebtsObject:debt];
        }
        
        if ([@"tab" isEqualToString:type]) {
            Bill *bill = t.bill;
            if (bill == nil) {
                bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:managedObjectContext];
                bill.transaction = t;
            }
            bill.photoUrl = [transactionJson objectForKey:@"photo"];
            bill.isDraft = [NSNumber numberWithInt:[[transactionJson objectForKey:@"is_draft"] boolValue] ? 1 : 0];
            bill.tip = [transactionJson objectForKey:@"tip"];
            bill.tax = [transactionJson objectForKey:@"tax"];
            bill.calculatedTotal = [transactionJson objectForKeyReturnNil:@"calculated_total"];
            bill.quickRotate = [transactionJson objectForKeyReturnNil:@"rotate"];
            
            //bill.items = [NSSet set];
            for (TransactionDebt *tmp in bill.items) {
                [managedObjectContext deleteObject:tmp];
            }
            [[bill mutableSetValueForKey:@"items"] removeAllObjects];

            NSArray *itemsJson = [transactionJson objectForKey:@"items"];
            for (id itemJson in itemsJson) {
                BillItem *billItem = [NSEntityDescription insertNewObjectForEntityForName:@"BillItem" inManagedObjectContext:managedObjectContext];
                billItem.bill = bill;
                billItem.amount = [itemJson objectForKey:@"amount"];
                billItem.descr = [itemJson objectForKey:@"description"];
                billItem.quickX = [itemJson objectForKeyReturnNil:@"quick_x"];
                billItem.quickY = [itemJson objectForKeyReturnNil:@"quick_y"];
                billItem.quickColor = [itemJson objectForKeyReturnNil:@"quick_color"];
                
                NSArray *itemContactsJson = [itemJson objectForKey:@"contacts"];
                for (id contactJson in itemContactsJson) {
                    BillItemContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"BillItemContact" inManagedObjectContext:managedObjectContext];
                    contact.item = billItem;
                    contact.contact = [ModelUtils fetchContactByServerId:[contactJson objectForKey:@"user"]];
                    contact.payAmount = [contactJson objectForKey:@"pay_amount"];
                }
            }
        }
    }
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error while saving transactions!! %@", error);
    }
    [self fireTransactionsSynced:page totalPages:numPages];
    if (page < numPages) {
        [self syncTransactions:page + 1];
        self->sync_lastsync = lastsync;
        return NO;
    }
    [defaults setInteger:lastsync forKey:@"lastsync"];
    
    return YES;
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
- (void) fireTransactionsSynced:(int) page totalPages:(int)totalPages {
    for (id listener in listeners) {
        [listener transactionsSynced:page totalPages:totalPages];
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
        if (syncinprogress) {
            [self syncTransactions:1];
        }
    } else if (request.tag == SyncTransactions) {
        [self handleTransactionsResponse: obj];
        if (syncinprogress) {
            // we are done with the sync :)
            syncinprogress = NO;
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"Handle error!!!! %@", error);
}

@end

