//
//  TabViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionAwareController.h"
#import "EGOImageView.h"
#import "AppDelegate.h"
#import "BillItem.h"
#import "BillItemContact.h"
#import "TabViewItemCell.h"
#import "TabViewItemParticipantCell.h"

@interface TabViewController : UIViewController<TransactionAwareController, UITableViewDataSource, EGOImageViewDelegate> {
    Transaction *transaction;
    NSFetchedResultsController *controller;
    NSFetchedResultsController *itemController;
    NSManagedObjectContext *managedObjectContext;
    NSMutableArray *itemTableObjects;

    int itemTableCount;
}
@property (weak, nonatomic) IBOutlet UITableView *participantTable;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsTotal;
@property (weak, nonatomic) IBOutlet UILabel *tipntax;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet EGOImageView *receiptPhoto;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *receiptPhotoLoading;
@property (weak, nonatomic) IBOutlet UITableView *itemTable;

@end
