//
//  Transaction.m
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "Transaction.h"
#import "Bill.h"
#import "Currency.h"
#import "TransactionContact.h"
#import "TransactionDebt.h"


@implementation Transaction

@dynamic serverId;
@dynamic descr;
@dynamic date;
@dynamic modifydate;
@dynamic type;
@dynamic photodata;
@dynamic status;
@dynamic syncstatus;
@dynamic syncstatuslastchange;
@dynamic currency;
@dynamic contacts;
@dynamic debts;
@dynamic bill;

@end
