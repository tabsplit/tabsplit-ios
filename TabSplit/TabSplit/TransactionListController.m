//
//  TransactionListController.m
//  TabSplit
//
//  Created by Herbert Poul on 11/4/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "TransactionListController.h"
#import "TransactionListCell.h"

#import "TransactionAwareController.h"

#import "AppDelegate.h"
#import "Transaction.h"

#import "FormatUtils.h"

@implementation TransactionListController


@synthesize contactObjectId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        managedObjectContext = [AppDelegate managedObjectContext];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    managedObjectContext = [AppDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
    
    if (self.contactObjectId != nil) {
        // only show transactions for the given contact id ..
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY contacts.contact == %@) AND status != 'deleted'", self.contactObjectId];
        [fetchRequest setPredicate:predicate];
        NSLog(@"only showing transactions for contact %@", self.contactObjectId);
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"status != 'deleted'", self.contactObjectId];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    controller = [[NSFetchedResultsController alloc]
                  initWithFetchRequest:fetchRequest
                  managedObjectContext:managedObjectContext
                  sectionNameKeyPath:nil
                  cacheName:nil];
    NSError *error = nil;
    [controller performFetch:&error];
    NSLog(@"Viewed transaction ...");

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"sections: %d", [[controller sections] count]);
    return [[controller sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[controller sections] objectAtIndex:section];
    NSLog(@"numberOfRows: %d", [sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransactionCell";
    
    TransactionListCell *cell = (TransactionListCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Transaction *t = [controller objectAtIndexPath:indexPath];
    
    cell.descriptionLabel.text = t.descr;
    cell.dateLabel.text = [FormatUtils formatDate:t.date];
    NSString *icon = @"ic_payment";
    if ([@"tab" isEqualToString:t.type] ){
        icon = @"ic_tab";
    } else if ([@"jointpayment" isEqualToString:t.type]) {
        icon = @"ic_jointpayment";
    }
    cell.typeImage.image = [UIImage imageNamed:icon];
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    Transaction *t = [controller objectAtIndexPath:indexPath];
    if ([t.type isEqualToString:@"tab"]) {
        [self performSegueWithIdentifier:@"showtab" sender:t];
    } else if ([t.type isEqualToString:@"payment"]) {
        [self performSegueWithIdentifier:@"showpayment" sender:t];
    } else if ([t.type isEqualToString:@"jointpayment"]) {
        [self performSegueWithIdentifier:@"showjointpayment" sender:t];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setTransaction:sender];
    
}

@end
