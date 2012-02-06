//
//  ContactListCell.m
//  TabSplit
//
//  Created by Herbert Poul on 10/17/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "ContactListCell.h"

@implementation ContactListCell

@synthesize nameLabel;
@synthesize emailLabel;
@synthesize imageView;
@synthesize debtLabel;
@synthesize alldebtLabel;
@synthesize contactId;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		imageView.frame = CGRectMake(4.0f, 4.0f, 36.0f, 36.0f);
        NSLog(@"init with style .. %@", self.contentView);
		[self.contentView addSubview:imageView];
	}
    
    return self;
}

- (void)setPhotoURL:(NSString*)photoURL {
    //NSLog(@"Setting photo URL ..");
	imageView.imageURL = [NSURL URLWithString:photoURL];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
    
	if(!newSuperview) {
		[imageView cancelImageLoad];
	}
}


@end
