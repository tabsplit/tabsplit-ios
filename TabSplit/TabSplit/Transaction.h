//
//  Transaction.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill, Currency, TransactionContact, TransactionDebt;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * modifydate;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSData * photodata;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * syncstatus;
@property (nonatomic, retain) NSDate * syncstatuslastchange;
@property (nonatomic, retain) Currency *currency;
@property (nonatomic, retain) NSSet *contacts;
@property (nonatomic, retain) NSSet *debts;
@property (nonatomic, retain) Bill *bill;
@end

@interface Transaction (CoreDataGeneratedAccessors)

- (void)addContactsObject:(TransactionContact *)value;
- (void)removeContactsObject:(TransactionContact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addDebtsObject:(TransactionDebt *)value;
- (void)removeDebtsObject:(TransactionDebt *)value;
- (void)addDebts:(NSSet *)values;
- (void)removeDebts:(NSSet *)values;

@end
