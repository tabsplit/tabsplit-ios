//
//  Currency.m
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "Currency.h"
#import "AppDelegate.h"


@implementation Currency

@dynamic isocode;
@dynamic label;
@dynamic serverId;
@dynamic symbol;
@dynamic updated;


+ (Currency*)fetchCurrencyByServerId: (NSNumber *)serverid {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Currency"];
    request.predicate = [NSPredicate predicateWithFormat:@"serverId = %@", serverid];
    NSError *error = nil;
    NSArray *res = [[AppDelegate managedObjectContext] executeFetchRequest:request error:&error];
    if (res == nil) {
        // handle error
    }
    if ([res count] < 1) {
        return nil;
    }
    return [res objectAtIndex:0];
}

@end
