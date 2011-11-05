//
//  ContactListTableViewController.m
//  TabSplit
//
//  Created by Herbert Poul on 10/17/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "AppDelegate.h"
#import "Contact.h"
#import "ContactDebt.h"
#import "ContactListCell.h"
#import "Currency.h"
#import "TransactionListController.h"


@implementation ContactListTableViewController

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
    
    managedObjectContext = [AppDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"fullName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    controller = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:managedObjectContext
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
    NSError *error = nil;
    [controller performFetch:&error];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [[controller sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[controller sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactListCell *cell = (ContactListCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Contact *managedObject = [controller objectAtIndexPath:indexPath];
    //cell.textLabel.text = managedObject.fullName;
//    UILabel *text = (UILabel *)[cell viewWithTag:100];
//    text.text = managedObject.fullName;
    cell.nameLabel.text = managedObject.fullName;
    
//    UILabel *emailText = (UILabel *)[cell viewWithTag:102];
//    emailText.text = managedObject.email;
    cell.emailLabel.text = managedObject.email;
    
    NSString *debt = @"0";
    NSString *alldebt = @"";
    
    int currentCurrency = 1;
    
    for (ContactDebt *cd in managedObject.contactDebts) {
        int amount = [cd.amount intValue];
        NSString *tmpdebt = [NSString stringWithFormat:@"%@ %d.%02d",cd.currency.isocode, (int)( amount / 100 ), abs(amount % 100)];
        if (currentCurrency == [cd.currency.serverId intValue]) {
            debt = tmpdebt;
        } else {
            if (![alldebt isEqualToString:@""]) {
                alldebt = [alldebt stringByAppendingString:@", "];
            }
            alldebt = [alldebt stringByAppendingString:tmpdebt];
        }
    }
    
    cell.debtLabel.text = debt;
    cell.alldebtLabel.text = alldebt;
    cell.contactId = [managedObject objectID];

    
//    EGOImageView *iv = (EGOImageView *)[cell viewWithTag:101];
//    iv.imageURL = [NSURL URLWithString:managedObject.avatarUrl];
    [cell setPhotoURL:managedObject.avatarUrl];
    

    
    return cell;
}

-(void) loadImage:(NSArray *)array {
    Contact *c = [array objectAtIndex:0];
    UITableViewCell *cell = [array objectAtIndex:1];
    
    if (c.avatarUrl != nil) {
        NSLog(@"Loading image %@", c.avatarUrl);
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:c.avatarUrl]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        [self performSelectorOnMainThread:@selector(displayImage:) withObject:[NSArray arrayWithObjects:cell, image, nil] waitUntilDone:NO];
    }
}

-(void) displayImage:(NSArray *)array {
    NSLog(@"Displaying image.");
    UITableViewCell *cell = [array objectAtIndex:0];
    UIImage *image = [array objectAtIndex:1];
    cell.imageView.image = image;
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
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"CONTACT Preparing for segue .. %@", sender);
    if ([[segue identifier] isEqualToString:@"transactionsforcontact"]) {
        TransactionListController *listController = [segue destinationViewController];
        listController.contactObjectId = ((ContactListCell *)sender).contactId;
    }
}

@end
