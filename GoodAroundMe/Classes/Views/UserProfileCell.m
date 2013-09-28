//
//  UserProfileCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "UserProfileCell.h"
#import "User+Create.h"

@interface UserProfileCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;

@end

@implementation UserProfileCell

- (void)setUser:(User *)user
{
    _user = user;
    if (_user) {
        NSLog(@"[DEBUG] <UserCell> Started for user: \nname:%@ %@ \nemail:%@ \nurl:%@", user.firstname, user.lastname, user.email, user.thumbnailURL);
        [self.userImageView setImageWithURL:[NSURL URLWithString:user.thumbnailURL]];
        self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.userImageView.layer.cornerRadius = 10; 
        self.userImageView.clipsToBounds = YES;
        self.userImageView.backgroundColor = [UIColor lightGrayColor];
        
        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
        
        self.followingLabel.text = [NSString stringWithFormat:@"%@ is following %d organizations", user.firstname, [user.following count]];
    }
}

@end
