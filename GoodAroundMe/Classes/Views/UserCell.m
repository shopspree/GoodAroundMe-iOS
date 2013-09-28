//
//  UserCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UserCell.h"
#import "UIImage+Resize.h"

@interface UserCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;

@end

@implementation UserCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.user) {
        [self.imageView setImageWithURL:[NSURL URLWithString:self.user.thumbnailURL]];
        self.imageView.image = [self.imageView.image scaleToSize:self.imageView.frame.size];
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstname, self.user.lastname];
    }
    
    NSLog(@"[LikeCell] <layoutSubviews> User cell with user: %@", [self.user log]);
}

@end
