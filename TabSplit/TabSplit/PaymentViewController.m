//
//  PaymentViewController.m
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "PaymentViewController.h"

#import "FormatUtils.h"
#import "TransactionContact.h"
#import "Contact.h"
#import "AppDelegate.h"

@implementation PaymentViewController
@synthesize descriptionLabel;
@synthesize dateLabel;
@synthesize contactAvatar;
@synthesize contactLabel;
@synthesize contactEmail;
@synthesize paymentDescriber;

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
    
    [AppDelegate trackPageView:@"/paymentview"];
    descriptionLabel.text = transaction.descr;
    dateLabel.text = [FormatUtils formatDate:transaction.date];
    
    TransactionContact *tc;
    // find the "other" contact :)
    for (TransactionContact *contact in transaction.contacts) {
        if ([contact.contact.ismyself intValue] == 0) {
            tc = contact;
        }
    }
    contactAvatar.imageURL = [NSURL URLWithString:tc.contact.avatarUrl];
    contactLabel.text = tc.contact.fullName;
    contactEmail.text = tc.contact.email;
    NSString *amount = [FormatUtils formatAmount:abs([tc.effectiveAmount intValue]) withCurrency:transaction.currency];
    if ([tc.effectiveAmount intValue] < 0) {
        paymentDescriber.text = [NSString stringWithFormat:@"You paid %@.", amount];
    } else {
        paymentDescriber.text = [NSString stringWithFormat:@"You were paid back %@.", amount];
    }
}

- (void)viewDidUnload
{
    [self setDescriptionLabel:nil];
    [self setDateLabel:nil];
    [self setContactAvatar:nil];
    [self setContactLabel:nil];
    [self setContactEmail:nil];
    [self setPaymentDescriber:nil];
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
