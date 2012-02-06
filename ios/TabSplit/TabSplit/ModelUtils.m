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
    return [self fetchObjectByServerId:serverid withEntityName:@"Contact"];
}
+ (Contact*)fetchMyself {
    return [self fetchObjectByPredicate:[NSPredicate predicateWithFormat:@"ismyself != 0"] withEntityName:@"Contact"];
}

+ (id)fetchObjectByPredicate:(NSPredicate *)predicate withEntityName:(NSString*)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *res = [[AppDelegate managedObjectContext] executeFetchRequest:request error:&error];
    if (res == nil) {
        // handle error
        NSLog(@"Error while trying to find entity: %@", error);
    }
    if ([res count] < 1) {
        NSLog(@"Unable to find entity.");
        return nil;
    }
    return [res objectAtIndex:0];
}




+ (Currency*)fetchCurrencyByServerId: (NSNumber *)serverid {
    return [self fetchObjectByServerId:serverid withEntityName:@"Currency"];
}
+ (Transaction*)fetchTransactionByServerId: (NSNumber *)serverid {
    return [self fetchObjectByServerId:serverid withEntityName:@"Transaction"];
}

+ (id)fetchObjectByServerId: (NSNumber *)serverid withEntityName:(NSString*)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
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
