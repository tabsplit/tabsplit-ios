//
//  BillItemContact.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BillItem, Contact;

@interface BillItemContact : NSManagedObject

@property (nonatomic, retain) NSNumber * payAmount;
@property (nonatomic, retain) BillItem *item;
@property (nonatomic, retain) Contact *contact;

@end
