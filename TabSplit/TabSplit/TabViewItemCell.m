//
//  TabViewItemCell.m
//  TabSplit
//
//  Created by Herbert Poul on 11/16/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "TabViewItemCell.h"

@implementation TabViewItemCell

@synthesize itemLabel;
@synthesize itemAmount;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
