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
        self.usernameLabel.text = self.user.displayName;
        
        // TO DO: Bug - why does the storyboard UIImageView not appear while when setting a new one - it does?
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        [imageView2 setImageWithURL:[NSURL URLWithString:self.user.thumbnailURL]];
        [self.contentView addSubview:imageView2];
        
        //self.imageView.backgroundColor = [UIColor lightGrayColor];
        //[self.imageView setImageWithURL:[NSURL URLWithString:self.user.thumbnailURL]];
        //self.imageView.image = [self.imageView.image scaleToSize:self.imageView.frame.size];
        
        
    }
    
    NSLog(@"[LikeCell] <layoutSubviews> User cell with user: %@", [self.user log]);
}

@end
