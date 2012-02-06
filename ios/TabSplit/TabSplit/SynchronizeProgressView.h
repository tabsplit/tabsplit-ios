//
//  SynchronizeProgressView.h
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncDelegate.h"

@interface SynchronizeProgressView : UIViewController<SyncDelegate>


@property (strong, nonatomic) IBOutlet UIProgressView *progressDialog;
@property (strong, nonatomic) IBOutlet UILabel *statusMessage;
@property (strong, nonatomic) IBOutlet UILabel *loginStatus;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;



@end
