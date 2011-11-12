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

@implementation TabViewController
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize itemsTotal;
@synthesize tipntax;
@synthesize total;
@synthesize receiptPhoto;

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
    
    receiptPhoto.imageURL = [NSURL URLWithString:transaction.bill.photoUrl];
    NSLog(@"loading photo from %@",  [NSURL URLWithString:transaction.bill.photoUrl]);
}

- (void)viewDidUnload
{
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setItemsTotal:nil];
    [self setTipntax:nil];
    [self setTotal:nil];
    [self setReceiptPhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
