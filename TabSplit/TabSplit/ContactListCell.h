//
//  ContactListCell.h
//  TabSplit
//
//  Created by Herbert Poul on 10/17/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ContactListCell : UITableViewCell {

    
}

- (void) setPhotoURL:(NSString*)photoURL;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) IBOutlet UILabel *emailLabel;

@property (nonatomic, strong) IBOutlet UILabel *debtLabel;

@property (nonatomic, strong) IBOutlet UILabel *alldebtLabel;


@property (nonatomic, strong) IBOutlet EGOImageView *imageView;


@end
