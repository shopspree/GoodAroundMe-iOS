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

@end

@implementation OrganizationCell

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    if (organization) {
        NSLog(@"[DEBUG] Set cell with %@ organization", organization.name);
        [self.organizationImage setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        
        self.organizationName.text = organization.name;
        self.subtitle.text = [NSString stringWithFormat:@"%@ followers  %@ posts", organization.followers_count, organization.posts_count];
        
        //NSString *title = ([organization.is_followed boolValue]) ? @"✓Follow" : @"Follow";
        //[self.followButton setTitle:title forState:UIControlStateNormal];
        self.followButton.highlighted = [organization.is_followed boolValue];
        self.followButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
}

@end
