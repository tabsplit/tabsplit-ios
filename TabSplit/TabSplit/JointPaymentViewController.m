//
//  JointPaymentViewController.m
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "JointPaymentViewController.h"
#import "JointPaymentParticipantCell.h"

#import "Transaction.h"
#import "TransactionContact.h"
#import "Contact.h"
#import "FormatUtils.h"

@implementation JointPaymentViewController
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize participantTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) setTransaction:(Transaction *)t {
    self->transaction = t;
}

#pragma mark - Private Methods

- (void)scaleTableToContents {
    [participantTable setFrame:CGRectMake(participantTable.frame.origin.x,
                                  participantTable.frame.origin.y,
                                  participantTable.contentSize.width,
                                  participantTable.contentSize.height)];
    
    //[container setContentSize:[theTable contentSize]];
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    managedObjectContext = [AppDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TransactionContact"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transaction == %@", transaction];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"contact.fullName" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    controller = [[NSFetchedResultsController alloc]
                  initWithFetchRequest:fetchRequest
                  managedObjectContext:managedObjectContext
                  sectionNameKeyPath:nil
                  cacheName:nil];
    NSError *error = nil;
    [controller performFetch:&error];

    
    
    
    
    participantTable.dataSource = self;
    
    
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(animated) {
        [self scaleTableToContents];
    } else {
        [self performSelector:@selector(scaleTableToContents) withObject:nil afterDelay:0.3];
    }
}

- (void)viewDidUnload
{
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setParticipantTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - table datasources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[controller sections] objectAtIndex:section];
    NSLog(@"numberOfRows: %d", [sectionInfo numberOfObjects]);
    
    return [sectionInfo numberOfObjects];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"JointPaymentCell";
    
    JointPaymentParticipantCell *cell = (JointPaymentParticipantCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    TransactionContact *tc = [controller objectAtIndexPath:indexPath];
    
    descriptionLabel.text = transaction.descr;
    dateLabel.text = [FormatUtils formatDate:transaction.date];
    
    cell.avatar.imageURL = [NSURL URLWithString:tc.contact.avatarUrl];
    cell.nameLabel.text = tc.contact.fullName;
    cell.email.text = tc.contact.email;
    if ([tc.payAmount intValue] > 0) {
        cell.amount.text = [FormatUtils formatAmount:[tc.payAmount intValue] withCurrency:transaction.currency];
    } else {
        cell.amount.text = @"";
    }

    return cell;
}

@end
