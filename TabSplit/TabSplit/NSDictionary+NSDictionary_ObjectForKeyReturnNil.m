//
//  NSDictionary+NSDictionary_ObjectForKeyReturnNil.m
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "NSDictionary+NSDictionary_ObjectForKeyReturnNil.h"

@implementation NSDictionary (NSDictionary_ObjectForKeyReturnNil)

- (id)objectForKeyReturnNil:(id)aKey {
	if ([aKey isKindOfClass:[NSNull class]]) {
		return nil;
	} else {
		id val = [self objectForKey:aKey];
        if ([val isKindOfClass:[NSNull class]]) {
            return nil;
        }
        return val;
	}
}

@end
