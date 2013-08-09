//
//  MoreOptionsViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/13/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "MoreOptionsViewController.h"
#import "Picture.h"

@interface MoreOptionsViewController ()

@end

@implementation MoreOptionsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)saveToCameraRollButtonClicked:(id)sender
{
    if (self.post) {
        // iterate over all the picture in the post
        for (Picture *picture in self.post.pictures) {
            NSString *urlString = picture.url;
            NSURL *url = [NSURL URLWithString:urlString];
            [self saveFileFromURL:url];
        }
    }
    
    [self done];
}

- (IBAction)reportInappropriateButtonClicked:(id)sender
{
    if (self.post) {
        [self.post inappropriate:^{
            [self done];
        } failure:^(NSDictionary *errorData) {
            // TO DO: notify user something went wrong
        }];
    }
}

#pragma mark - private methods

- (void)saveFileFromURL:(NSURL *)url
{
    if (url) {
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);   
    }
}

- (void)done
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

@end
