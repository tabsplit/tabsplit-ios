//
//  TabViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionAwareController.h"

@interface TabViewController : UIViewController<TransactionAwareController> {
    Transaction *transaction;
}

@end
