//
//  TransactionListController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionListController : UITableViewController {
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *controller;
}

@property (nonatomic, strong) NSManagedObjectID *contactObjectId;

@end
