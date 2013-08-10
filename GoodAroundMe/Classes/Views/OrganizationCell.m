//
//  OrganizationCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "OrganizationCell.h"

@interface OrganizationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *organizationImage;
@property (weak, nonatomic) IBOutlet UILabel *organizationName;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end

@implementation OrganizationCell

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    if (organization) {
        [self.organizationImage setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        
        self.organizationName.text = organization.name;
        self.subtitle.text = [NSString stringWithFormat:@"%@ followers  %@ posts", organization.followers_count, organization.posts_count];
        
        if ([organization.is_followed boolValue]) {
            self.followButton.titleLabel.text = @"Following";
            self.followButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
            self.followButton.backgroundColor = [UIColor greenColor];
        } else {
            self.followButton.titleLabel.text = @"Follow";
            self.followButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            self.followButton.backgroundColor = [UIColor blueColor];
        }
    }
}

@end
