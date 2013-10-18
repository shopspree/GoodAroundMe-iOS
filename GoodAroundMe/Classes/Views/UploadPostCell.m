//
//  UploadPostCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/22/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UploadPostCell.h"

@interface UploadPostCell ()
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *uploadProgressBar;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation UploadPostCell

- (void)setPostDictionary:(NSDictionary *)postDictionary
{
    _postDictionary = postDictionary;
    if (postDictionary) {
        // TO DO
    }
}

@end
