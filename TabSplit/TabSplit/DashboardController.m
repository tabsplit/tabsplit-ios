//
//  InitialViewController.m
//  TabSplit
//
//  Created by Herbert Poul on 10/15/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "DashboardController.h"
#import "AppDelegate.h"
#import "ModelUtils.h"

@implementation DashboardController
@synthesize loginStatus;
@synthesize loggedinAvatar;

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        NSLog(@"initializing ... 222");
        didStartBrowserBefore = 0;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"initializing ...");
        didStartBrowserBefore = 0;
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

- (void)viewDidAppear:(BOOL)animated {
    //[self ensureSync];
    [self toforeground:nil];
    //[self performSegueWithIdentifier:@"reloadData" sender:nil];
    NSLog(@"viewDidAppear");
    [AppDelegate trackPageView:@"/dashboard"];
}

- (void)viewDidLoad {
    NSLog(@"view did load. %d", didStartBrowserBefore);
    didStartBrowserBefore = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toforeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didbecomeactive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)toforeground:(NSNotification *)note {
    NSLog(@"Comes to foreground! %d", didStartBrowserBefore);
    if (didStartBrowserBefore != 3) {
        didStartBrowserBefore = 3;
        [self ensureSync];
    } else {
        NSLog(@"delayed ensureSync");
        [self performSelector:@selector(ensureSync) withObject:nil afterDelay:0.5];
    }
}
- (void)didbecomeactive:(NSNotification *)note {
    NSLog(@"Did become active");
}

- (void) ensureSync {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSLog(@"Ensuring login ..");
    if ([delegate ensureLogin]) {
        if (![delegate ensureSync]) {
            NSLog(@"logged in, start sync");
            [self performSegueWithIdentifier:@"startsync" sender:self];
            loginStatus.text = @"Not synchronized.";
        } else {
            NSLog(@"Logged in and synced :) ");
            Contact *myself = [ModelUtils fetchMyself];
            if (myself) {
                loginStatus.text = [NSString stringWithFormat:@"Welcome %@!", myself.fullName];
                loggedinAvatar.imageURL = [NSURL URLWithString:myself.avatarLargeUrl];
            } else {
                NSLog(@"Error - logged in and synced, but no 'myself'?!");
            }
        }
    } else {
        loginStatus.text = @"Not logged in.";
    }
    
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setLoginStatus:nil];
    [self setLoggedinAvatar:nil];
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
