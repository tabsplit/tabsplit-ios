//
//  BillItem.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill, BillItemContact;

@interface BillItem : NSManagedObject

@property (nonatomic, retain) NSString * descr;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * quickX;
@property (nonatomic, retain) NSNumber * quickY;
@property (nonatomic, retain) NSString * quickColor;
@property (nonatomic, retain) Bill *bill;
@property (nonatomic, retain) NSSet *contacts;
@end

@interface BillItem (CoreDataGeneratedAccessors)

- (void)addContactsObject:(BillItemContact *)value;
- (void)removeContactsObject:(BillItemContact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

@end
