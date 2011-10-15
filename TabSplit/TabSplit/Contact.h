//
//  Contact.h
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "AppDelegate.h"


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * avatarUrl;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * ismyself;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * userName;


+ (Contact*)fetchContactByServerId: (NSNumber *)serverid;


@end
