//
//  TransactionAwareController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Transaction.h"

@protocol TransactionAwareController <NSObject>

- (void) setTransaction:(Transaction *)transction;

@end
