//
//  AppDelegate.h
//  TabSplit
//
//  Created by Herbert Poul on 10/11/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (NSManagedObjectContext*) managedObjectContext;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) handleLogin;
- (BOOL) ensureLogin;
- (BOOL) ensureSync;



+ (void) trackPageView:(NSString *)page;


- (NSDictionary *)parseQueryString:(NSString *)query;


@end
