//
//  PaymentViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/5/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionAwareController.h"
#import "EGOImageView.h"

@interface PaymentViewController : UIViewController<TransactionAwareController> {
    Transaction *transaction;
}
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet EGOImageView *contactAvatar;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactEmail;
@property (weak, nonatomic) IBOutlet UILabel *paymentDescriber;

@end
