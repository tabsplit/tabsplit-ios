//
//  ContactDebt.h
//  TabSplit
//
//  Created by Herbert Poul on 10/18/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Currency;

@interface ContactDebt : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Currency *currency;

@end
