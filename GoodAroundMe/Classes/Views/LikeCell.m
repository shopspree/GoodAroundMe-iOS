//
//  LikeCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "LikeCell.h"
#import "User.h"

@interface LikeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation LikeCell

- (void)setLike:(Like *)like
{
    _like = like;
    if (like) {
        [self.imageView setImageWithURL:[NSURL URLWithString:like.user.thumbnailURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", like.user.firstname, like.user.lastname];
    }
}

@end
