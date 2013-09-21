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

//@property (weak, nonatomic) IBOutlet UIImageView *image1;
//@property (weak, nonatomic) IBOutlet UIImageView *image2;
//@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageMosaic;

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
        NSLog(@"[DEBUG] <OrganizationProfileCell> imageMosaic.count =  %d, imagePicks.count = %d", [self.imageMosaic count], [self.imagePicks count]);
        for (int i=0; i<[self.imageMosaic count]; i++) {
            UIImageView *imageView = self.imageMosaic[i];
            NSString *imageURL = (i < [self.imagePicks count]) ? self.imagePicks[i] : nil;
            [imageView setImageWithURL:[NSURL URLWithString:imageURL]];
        }

        [self.logoImage setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.logoImage.image = [self.logoImage.image scaleToSize:CGSizeMake(self.logoImage.frame.size.width, self.logoImage.frame.size.height)];
        self.logoImage.layer.borderWidth = 1.0f;
        self.logoImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
        self.nameLabel.text = organization.name;
        self.locationLabel.text = organization.location;
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
        if ([posts count] < [self.imageMosaic count]) {
            NSMutableArray *imagePicksCopy = [NSMutableArray arrayWithCapacity:[self.imageMosaic count]];
            for (int i=0; i<[posts count]; i++) {
                Post *post = [posts objectAtIndex:i];
                Picture *picture = [[post.pictures allObjects] lastObject];
                
                if (picture) {
                    [imagePicksCopy addObject:picture.url];
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
                
            } while ([picks count] < [self.imageMosaic count]);
            _imagePicks = [picks allObjects];
        }
        
    }
    
    return _imagePicks;
}

@end
