//
//  FormatUtils.m
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "FormatUtils.h"

@implementation FormatUtils

+ (NSString *) formatDate:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) formatAmount:(int) amount withCurrency:(Currency *)currency {
    int cent = abs(amount % 100);
    int full = amount / 100;
    return [NSString stringWithFormat:@"%@ %d.%02d", currency.isocode, full, cent];
}


@end
