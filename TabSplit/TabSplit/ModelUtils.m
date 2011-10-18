//
//  ModelUtils.m
//  TabSplit
//
//  Created by Herbert Poul on 10/18/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "ModelUtils.h"

@implementation ModelUtils



+ (Contact*)fetchContactByServerId: (NSNumber *)serverid {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
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
