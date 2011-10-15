//
//  Currency.h
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Currency : NSManagedObject

@property (nonatomic, retain) NSString * isocode;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * symbol;
@property (nonatomic, retain) NSDate * updated;

+ (Currency*)fetchCurrencyByServerId:(NSNumber *)id;

@end
