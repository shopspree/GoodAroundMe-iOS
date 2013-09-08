//
//  OrganizationProfileCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "OrganizationProfileCell.h"
#import "OrganizationCategory+Create.h"
#import "UIImage+Resize.h"
#import "Post+Create.h"
#import "Picture+Create.h"

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

@property (nonatomic, strong) NSArray *imagePicks;

@end

@implementation OrganizationProfileCell

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    if (organization) {
        [self.image1 setImageWithURL:[NSURL URLWithString:self.imagePicks[0]] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        [self.image2 setImageWithURL:[NSURL URLWithString:self.imagePicks[1]] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        [self.image3 setImageWithURL:[NSURL URLWithString:self.imagePicks[2]] placeholderImage:[UIImage imageNamed:@"Default.png"]];

        [self.logoImage setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.logoImage.image = [self.logoImage.image scaleToSize:CGSizeMake(self.logoImage.frame.size.width, self.logoImage.frame.size.height)];
        self.logoImage.layer.borderWidth = 1.0f;
        self.logoImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
        self.nameLabel.text = organization.name;
        self.categoryLabel.text = organization.category.name;
        self.updatesLabel.text = [NSString stringWithFormat:@"%@ Updates", organization.posts_count];
        self.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", organization.followers_count];
        self.descriptionTextArea.text = organization.about;
    }
}

- (NSArray *)imagePicks
{
    if (! _imagePicks) {
        NSMutableSet *picks = [NSMutableSet set];
        NSArray *posts = [self.organization.posts allObjects];
        if ([posts count] < 3) {
            NSMutableArray *imagePicksCopy = [NSMutableArray arrayWithCapacity:3];
            for (int i=0; i<[posts count]; i++) {
                Post *post = [posts objectAtIndex:i];
                Picture *picture = [[post.pictures allObjects] lastObject];
                
                if (picture) {
                    [imagePicksCopy addObject:post];
                }
            }
            _imagePicks = imagePicksCopy;
        } else {
            do {
                NSInteger index = arc4random() % [posts count];
                Post *post = [posts objectAtIndex:index];
                Picture *picture = [[post.pictures allObjects] lastObject];
                
                if (picture) {
                    [picks addObject:picture.url];
                }
                
            } while ([picks count] < 3);
            _imagePicks = [picks allObjects];
        }
        
    }
    
    return _imagePicks;
}

@end
