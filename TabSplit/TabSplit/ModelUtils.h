//
//  ModelUtils.h
//  TabSplit
//
//  Created by Herbert Poul on 10/18/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contact.h"
#import "Currency.h"
#import "AppDelegate.h"
#import "Transaction.h"

@interface ModelUtils : NSObject


+ (Contact*)fetchContactByServerId: (NSNumber *)serverid;
+ (Currency*)fetchCurrencyByServerId: (NSNumber *)serverid;
+ (Transaction*)fetchTransactionByServerId: (NSNumber *)serverid;

+ (id) fetchObjectByServerId: (NSNumber *)serverid withEntityName:(NSString*)entityName;

@end
