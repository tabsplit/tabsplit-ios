//
//  FormatUtils.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface FormatUtils : NSObject

+ (NSString *) formatDate:(NSDate *) date;
+ (NSString *) formatAmount:(int) amount withCurrency:(Currency *)currency;

@end
