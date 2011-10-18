//
//  Contact.h
//  TabSplit
//
//  Created by Herbert Poul on 10/18/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactDebt;

@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * ismyself;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSSet *contactDebts;
@end

@interface Contact (CoreDataGeneratedAccessors)

- (void)addContactDebtsObject:(ContactDebt *)value;
- (void)removeContactDebtsObject:(ContactDebt *)value;
- (void)addContactDebts:(NSSet *)values;
- (void)removeContactDebts:(NSSet *)values;

@end
