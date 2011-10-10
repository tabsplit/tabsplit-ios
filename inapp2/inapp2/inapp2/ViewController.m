//
//  ViewController.m
//  inapp2
//
//  Created by Herbert Poul on 10/10/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"hatschi");
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
    
    NSLog(@"muhahhahaha");
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    
    NSLog(@"Trying to get info about ");
    
    
    
    
    NSLog(@"Getting product data");
	//NSSet *productIdentifiers = [NSSet setWithObject:@"com.austrianapps.ios.inapptest2.11"];
    NSSet *productIdentifiers = [NSSet setWithObject:@"NDWF85EBJH.com.austrianapps.ios.inapptest2.11"];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    
    productsRequest.delegate = self;
    [productsRequest start];

    
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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}






// SKPaymentTransactionObserver methods
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSString *state, *error, *transactionIdentifier, *transactionReceipt, *productId;
	NSInteger errorCode;
    
    for (SKPaymentTransaction *transaction in transactions)
    {
		error = state = transactionIdentifier = transactionReceipt = productId = @"";
		errorCode = 0;
        
        switch (transaction.transactionState)
        {
			case SKPaymentTransactionStatePurchasing:
				continue;
                
            case SKPaymentTransactionStatePurchased:
				state = @"PaymentTransactionStatePurchased";
				transactionIdentifier = transaction.transactionIdentifier;
				transactionReceipt = [[transaction transactionReceipt] base64EncodedString];
				productId = transaction.payment.productIdentifier;
                break;
                
			case SKPaymentTransactionStateFailed:
				state = @"PaymentTransactionStateFailed";
				error = transaction.error.localizedDescription;
				errorCode = transaction.error.code;
                NSDictionary* userinfo = transaction.error.userInfo;
				NSLog(@"error %d %@ -- %@ -- %@", errorCode, error, transaction.error, userinfo);
                
                break;
                
			case SKPaymentTransactionStateRestored:
				state = @"PaymentTransactionStateRestored";
				transactionIdentifier = transaction.originalTransaction.transactionIdentifier;
				transactionReceipt = [[transaction transactionReceipt] base64EncodedString];
				productId = transaction.originalTransaction.payment.productIdentifier;
                break;
                
            default:
				NSLog(@"Invalid state");
                continue;
        }
		NSLog(@"state: %@", state);
		NSString *js = [NSString stringWithFormat:@"plugins.inAppPurchaseManager.updatedTransactionCallback('%@',%d, '%@','%@','%@','%@')", state, errorCode, error, transactionIdentifier, productId, transactionReceipt ];
		NSLog(@"js: %@", js);
		//[self writeJavascript: js];
		[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        
    }
}






- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	NSLog(@"got iap product response");
    for (SKProduct *product in response.products) {
		NSLog(@"sending js for %@", product.productIdentifier);
		NSString *js = [NSString stringWithFormat:@"%@('%@','%@','%@','%@')", @"success", product.productIdentifier, product.localizedTitle, product.localizedDescription, product.localizedTitle];
		NSLog(@"js: %@", js);
		//[command writeJavascript: js];
    }
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
		NSLog(@"sending fail (%@) js for %@", @"fail", invalidProductId);
        
		//[command writeJavascript: [NSString stringWithFormat:@"%@('%@')", @"fail", invalidProductId]];
    }
	NSLog(@"done iap");
    
	//[command writeJavascript: [NSString stringWithFormat:@"%@('__DONE')", successCallback]];
    
	[request release];
	[self release];
}




@end
