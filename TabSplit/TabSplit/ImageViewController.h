//
//  ImageViewController.h
//  TabSplit
//
//  Created by Herbert Poul on 11/16/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ImageViewController : UIViewController {
    NSURL *url;
}


@property (weak, nonatomic) IBOutlet EGOImageView *imageView;
-(void)setImageURL:(NSURL *)url;

@end
