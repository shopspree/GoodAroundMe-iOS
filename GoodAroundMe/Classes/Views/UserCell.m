//
//  UserCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "UserCell.h"
#import "User+Create.h"

@interface UserCell()

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@end

@implementation UserCell

- (void)setUser:(User *)user
{
    _user = user;
    if (_user) {
        [self.userImageButton setImageWithURL:[NSURL URLWithString:user.thumbnailURL]
                                     forState:UIControlStateNormal
                             placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.userImageButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.userImageButton.layer.cornerRadius = 10; 
        self.userImageButton.clipsToBounds = YES;
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
        
        self.followingLabel.text = [NSString stringWithFormat:@"%@ %@ is following %d organizations", user.firstname, user.lastname, [user.following count]];
    }
}

@end
