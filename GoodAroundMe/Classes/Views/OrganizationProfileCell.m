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
#import "UITextView+Truncate.h"

@interface OrganizationProfileCell ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageMosaic;

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
            self.imageView.backgroundColor = [UIColor lightGrayColor];
        }

        [self.logoImage setImageWithURL:[NSURL URLWithString:organization.image_thumbnail_url]];
        self.logoImage.image = [self.logoImage.image scaleToSize:CGSizeMake(self.logoImage.frame.size.width, self.logoImage.frame.size.height)];
        self.logoImage.layer.borderWidth = 1.0f;
        self.logoImage.layer.borderColor = [[UIColor grayColor] CGColor];
        
        self.nameLabel.text = organization.name;
        self.locationLabel.text = organization.location;
        self.categoryLabel.text = organization.category.name;
        self.updatesLabel.text = [NSString stringWithFormat:@"%@ Updates", organization.posts_count];
        self.followersLabel.text = [NSString stringWithFormat:@"%@ Followers", organization.followers_count];
        
        NSDictionary *attributedStringDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"GillSans-Light" size:14.0f], NSFontAttributeName, nil];
        self.aboutTextView.attributedText = [[NSAttributedString alloc] initWithString:organization.about attributes:attributedStringDict];
        [self.aboutTextView truncateToHeight];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToOrganizationInformation:)];
        tap.numberOfTapsRequired = 1;
        [self.aboutTextView addGestureRecognizer:tap];
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

- (IBAction)goToOrganizationInformation:(id)sender
{
    [self.delegate goToOrganizationInformation:sender];
}

@end
