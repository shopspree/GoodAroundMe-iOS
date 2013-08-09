//
//  LikeCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UserCell.h"
#import "User.h"

@interface UserCell()
@property (nonatomic, weak) IBOutlet UIImageView *userThumbnailImage;
@property (nonatomic, weak) IBOutlet UILabel *usernameLabel;

@end

@implementation UserCell

- (void)setUser:(User *)user
{
    _user = user;
    if (_user) {
        [self.userThumbnailImage setImageWithURL:[NSURL URLWithString:user.thumbnailURL]
                                placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
    }
}

@end
