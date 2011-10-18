//
//  ContactListTableViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 10/17/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListTableViewController : UITableViewController {
    NSManagedObjectContext *managedObjectContext;
    NSFetchedResultsController *controller;
}

-(void) loadImage:(NSArray *)array;
-(void) displayImage:(NSArray *)array;


@end
