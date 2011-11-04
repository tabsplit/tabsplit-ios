//
//  Bill.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSDate * photoLocalChange;
@property (nonatomic, retain) NSNumber * tip;
@property (nonatomic, retain) NSNumber * tax;
@property (nonatomic, retain) NSNumber * calculatedTotal;
@property (nonatomic, retain) NSNumber * isDraft;
@property (nonatomic, retain) NSNumber * quickRotate;
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) NSSet *items;
@end

@interface Bill (CoreDataGeneratedAccessors)

- (void)addItemsObject:(NSManagedObject *)value;
- (void)removeItemsObject:(NSManagedObject *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
