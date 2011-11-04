//
//  TransactionContact.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Transaction;

@interface TransactionContact : NSManagedObject

@property (nonatomic, retain) NSString * participantType;
@property (nonatomic, retain) NSNumber * payAmount;
@property (nonatomic, retain) NSNumber * effectiveAmount;
@property (nonatomic, retain) NSNumber * tipntaxsplit;
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) Contact *contact;

@end
