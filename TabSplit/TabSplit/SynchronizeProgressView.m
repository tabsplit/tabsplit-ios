//
//  SynchronizeProgressView.m
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "SynchronizeProgressView.h"

#import "SyncManager.h"

@implementation SynchronizeProgressView
@synthesize progressDialog;
@synthesize statusMessage;
@synthesize loginStatus;

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
- (IBAction)cancelClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    [progressDialog setProgress:0];
    
    statusMessage.text = @"Logging in...";
    [[SyncManager getInstance] forceSync];
    [[SyncManager getInstance] registerListener:self];
}

- (void)viewDidUnload
{
    [[SyncManager getInstance] unregisterListener:self];
    [self setProgressDialog:nil];
    [self setStatusMessage:nil];
    [self setLoginStatus:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loginResult:(BOOL) successful {
    NSString *username = [[SyncManager getInstance] getUsername];
    loginStatus.text = [NSString stringWithFormat:@"Welcome %@!", username];
    statusMessage.text = @"Synchronizing Currencies ...";
    progressDialog.progress = 0.2;
}

- (void)currenciesSynced {
    statusMessage.text = @"Synchronizing Contacts ...";
    progressDialog.progress = 0.4;
}

- (void)contactsSynced {
    statusMessage.text = @"Synchronization kind of done ;)";
    progressDialog.progress = 1;
}

@end
