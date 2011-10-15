//
//  SyncManager.h
//  TabSplit
//
//  Created by Herbert Poul on 10/11/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncDelegate.h"
#import "SBJson.h"

@interface SyncManager : NSObject {
    NSMutableArray *listeners;
    SBJsonParser *_parser;
    
    NSManagedObjectContext *managedObjectContext;

    BOOL syncinprogress;
}

typedef enum _RequestTag {
    RequestLogin = 1,
    SyncCurrency = 2,
    SyncContacts = 3,
} RequestTag;

+ (SyncManager *)getInstance;

- (NSString *)getUsername;



- (void) forceSync;
- (void) verifyLogin;

- (void) registerListener:(id) delegate;
- (void) unregisterListener:(id) delegate;



// internal
- (void) requestJSON:(NSString *)path tag:(RequestTag) tag;
- (void) fireLoginResult:(BOOL)successful;
- (void) fireCurrenciesSynced;
- (void) fireContactsSynced;
- (void) syncCurrencies;
- (void) handleCurrencyResponse:(id) obj;
- (void) syncContacts;
- (void) handleContactsResponse:(id) obj;


@end

