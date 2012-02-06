//
//  TabViewController.m
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "TabViewController.h"

#import "Bill.h"
#import "Transaction.h"

#import "JointPaymentParticipantCell.h"
#import "FormatUtils.h"
#import "TransactionContact.h"
#import "Contact.h"

@implementation TabViewController
@synthesize participantTable;
@synthesize containerView;
@synthesize scrollView;
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize itemsTotal;
@synthesize tipntax;
@synthesize total;
@synthesize receiptPhoto;
@synthesize receiptPhotoLoading;
@synthesize itemTable;

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

    [AppDelegate trackPageView:@"/tabview"];

    receiptPhoto.delegate = self;
    receiptPhotoLoading.hidden = NO;
    receiptPhoto.imageURL = [NSURL URLWithString:[@"http://tabsplit.net/" stringByAppendingString:transaction.bill.photoUrl]];
    NSLog(@"loading photo from %@",  [NSURL URLWithString:transaction.bill.photoUrl]);
    
    
    
    
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
    
    
    // count the total number of items + participants
    itemTableCount = 0;
    itemTableObjects = [NSMutableArray array];
    for (BillItem* item in transaction.bill.items) {
        [itemTableObjects addObject:item];
        itemTableCount++;
        for (BillItemContact *contact in item.contacts) {
            [itemTableObjects addObject:contact];
        }
        itemTableCount += [item.contacts count];
    }
    
    
    
    participantTable.dataSource = self;
    itemTable.dataSource = self;

    
    
    scrollView.contentSize = [containerView sizeThatFits:CGSizeZero];
    
    
    NSString *tip = [FormatUtils formatAmount:[transaction.bill.tip intValue]  withCurrency:transaction.currency];
    NSString *tax = [FormatUtils formatAmount:[transaction.bill.tax intValue]  withCurrency:transaction.currency];
    tipntax.text = [NSString stringWithFormat:@"%@ + %@", tip, tax];
    int itemsTotalVal = [transaction.bill.calculatedTotal intValue] - [transaction.bill.tip intValue] - [transaction.bill.tax intValue];
    itemsTotal.text = [FormatUtils formatAmount:itemsTotalVal withCurrency:transaction.currency];
    total.text = [FormatUtils formatAmount:[transaction.bill.calculatedTotal integerValue] withCurrency:transaction.currency];
    
}

- (void)viewDidUnload
{
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setItemsTotal:nil];
    [self setTipntax:nil];
    [self setTotal:nil];
    [self setReceiptPhoto:nil];
    [self setScrollView:nil];
    [self setContainerView:nil];
    [self setParticipantTable:nil];
    [self setItemTable:nil];
    [self setReceiptPhotoLoading:nil];
    [self setReceiptPhotoLoading:nil];
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
    if (tableView == participantTable) {
        // Return the number of rows in the section.
        id <NSFetchedResultsSectionInfo> sectionInfo = [[controller sections] objectAtIndex:section];
        NSLog(@"numberOfRows: %d", [sectionInfo numberOfObjects]);
        
        return [sectionInfo numberOfObjects];
    } else if (tableView == itemTable) {
        return itemTableCount;
    }
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == participantTable) {
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
    } else if (tableView == itemTable) {
        id obj = [itemTableObjects objectAtIndex:[indexPath indexAtPosition:1]];
        if ([obj isKindOfClass:[BillItem class]]) {
            TabViewItemCell *cell = (TabViewItemCell*)[tableView dequeueReusableCellWithIdentifier:@"itemcell"];
            
            
            BillItem *item = (BillItem *)obj;
            cell.itemLabel.text = item.descr;
            cell.itemAmount.text = [FormatUtils formatAmount:[item.amount intValue] withCurrency:transaction.currency];
            
            
            return cell;
        } else {
            TabViewItemParticipantCell *cell = (TabViewItemParticipantCell*)[tableView dequeueReusableCellWithIdentifier:@"personcell"];
            BillItemContact *contact = (BillItemContact*)obj;
            
            cell.userName.text = contact.contact.fullName;
            cell.avatar.imageURL = [NSURL URLWithString:contact.contact.avatarUrl];
            
            return cell;
        }
        return nil;
    }
    return nil;
}


- (void)imageViewLoadedImage:(EGOImageView*)imageView {
    receiptPhotoLoading.hidden = YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[segue destinationViewController] setImageURL:[NSURL URLWithString:[@"http://tabsplit.net/" stringByAppendingString:transaction.bill.photoUrl]]];
}



@end
