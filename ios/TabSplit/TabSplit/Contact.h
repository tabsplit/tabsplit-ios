//
//  Contact.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillItemContact, ContactDebt, TransactionContact, TransactionDebt;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * ismyself;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * avatarLargeUrl;
@property (nonatomic, retain) NSSet *contactDebts;
@property (nonatomic, retain) NSSet *transactionContacts;
@property (nonatomic, retain) NSSet *transdebta;
@property (nonatomic, retain) NSSet *transdebtb;
@property (nonatomic, retain) NSSet *billItemContacts;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addContactDebtsObject:(ContactDebt *)value;
- (void)removeContactDebtsObject:(ContactDebt *)value;
- (void)addContactDebts:(NSSet *)values;
- (void)removeContactDebts:(NSSet *)values;

- (void)addTransactionContactsObject:(TransactionContact *)value;
- (void)removeTransactionContactsObject:(TransactionContact *)value;
- (void)addTransactionContacts:(NSSet *)values;
- (void)removeTransactionContacts:(NSSet *)values;

- (void)addTransdebtaObject:(TransactionDebt *)value;
- (void)removeTransdebtaObject:(TransactionDebt *)value;
- (void)addTransdebta:(NSSet *)values;
- (void)removeTransdebta:(NSSet *)values;

- (void)addTransdebtbObject:(TransactionDebt *)value;
- (void)removeTransdebtbObject:(TransactionDebt *)value;
- (void)addTransdebtb:(NSSet *)values;
- (void)removeTransdebtb:(NSSet *)values;

- (void)addBillItemContactsObject:(BillItemContact *)value;
- (void)removeBillItemContactsObject:(BillItemContact *)value;
- (void)addBillItemContacts:(NSSet *)values;
- (void)removeBillItemContacts:(NSSet *)values;

@end
