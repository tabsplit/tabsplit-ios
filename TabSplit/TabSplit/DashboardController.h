//
//  InitialViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface DashboardController : UIViewController {
    int didStartBrowserBefore;
}
@property (weak, nonatomic) IBOutlet UILabel *loginStatus;
@property (weak, nonatomic) IBOutlet EGOImageView *loggedinAvatar;

- (void)toforeground: (NSNotification *)note;
- (void)ensureSync;
- (void)didbecomeactive:(NSNotification *)note;

@end
