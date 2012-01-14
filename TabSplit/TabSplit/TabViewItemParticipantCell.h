//
//  TabViewItemParticipantCell.h
//  TabSplit
//
//  Created by Herbert Poul on 11/16/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface TabViewItemParticipantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet EGOImageView *avatar;


@end
