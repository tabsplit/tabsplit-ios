//
//  TransactionDebt.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Transaction;

@interface TransactionDebt : NSManagedObject

@property (nonatomic, retain) NSNumber * debtamount;
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) Contact *contacta;
@property (nonatomic, retain) Contact *contactb;

@end
