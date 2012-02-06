//
//  Currency.h
//  TabSplit
//
//  Created by Herbert Poul on 10/18/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactDebt;

@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * isocode;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSDate * updated;
@property (nonatomic, retain) NSSet *contactDebts;
@end

@interface Currency (CoreDataGeneratedAccessors)

- (void)addContactDebtsObject:(ContactDebt *)value;
- (void)removeContactDebtsObject:(ContactDebt *)value;
- (void)addContactDebts:(NSSet *)values;
- (void)removeContactDebts:(NSSet *)values;

@end
