//
//  ViewController.h
//  inapp2
//
//  Created by Herbert Poul on 10/10/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface ViewController : UIViewController<SKPaymentTransactionObserver, SKProductsRequestDelegate>

@end
