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

static NSString *SYNCSTATUS_NOTMODIFIED = @"notmodified";

static NSString *TSAPIKEY = @"FjexqZRzrCshMMPBvJy9SV4qhrVEgANjTTve8MXF";

@interface SyncManager : NSObject {
    NSMutableArray *listeners;
    SBJsonParser *_parser;
    
    NSManagedObjectContext *managedObjectContext;

    BOOL syncinprogress;
    int sync_lastsync;
    
    
}

typedef enum _RequestTag {
    RequestLogin = 1,
    SyncCurrency = 2,
    SyncContacts = 3,
    SyncTransactions = 4,
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
- (void) fireTransactionsSynced:(int) page totalPages:(int)totalPages;
- (void) syncCurrencies;
- (void) handleCurrencyResponse:(id) obj;
- (void) syncContacts;
- (void) handleContactsResponse:(id) obj;
- (void) syncTransactions:(int)page;
/**
 * handles transactions response and returns YES
 * if it is done parsing transactions and NO
 * if it requested  the next page.
 */
- (BOOL) handleTransactionsResponse:(id) obj;


@end

