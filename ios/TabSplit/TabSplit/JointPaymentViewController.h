//
//  JointPaymentViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionAwareController.h"
#import "AppDelegate.h"
#import "EGOImageView.h"

@interface JointPaymentViewController : UIViewController<TransactionAwareController, UITableViewDataSource> {
    Transaction *transaction;
    NSManagedObjectContext *managedObjectContext;
    
    
    NSFetchedResultsController *controller;
}
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *participantTable;

@end
