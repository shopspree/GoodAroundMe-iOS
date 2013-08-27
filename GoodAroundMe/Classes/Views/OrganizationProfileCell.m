//
//  OrganizationProfileCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "OrganizationProfileCell.h"
#import "OrganizationCategory+Create.h"

@interface OrganizationProfileCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *fundsLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextArea;

@end

@implementation OrganizationProfileCell

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    if (organization) {
        [self.image1 setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        [self.image2 setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        [self.image3 setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        
        [self.logoImage setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.nameLabel.text = organization.name;
        self.categoryLabel.text = organization.category.name;
        self.updatesLabel.text = [NSString stringWithFormat:@"%@ Updates", organization.posts_count];
        self.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", organization.followers_count];
        self.descriptionTextArea.text = organization.about;
    }
}

@end
