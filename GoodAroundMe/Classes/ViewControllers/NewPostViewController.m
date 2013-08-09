//
//  NewPostViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/15/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "NewPostViewController.h"
#import "Post+Create.h"
#import "Picture+Create.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.postDictionary = [NSMutableDictionary dictionary];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)setPostDictionary:(NSMutableDictionary *)postDictionary
{
    _postDictionary = postDictionary;
    
    NSDictionary *mediaDictionary = postDictionary[POST_MEDIAS];
    if (mediaDictionary) {
        if ([mediaDictionary[MEDIA_TYPE] isEqualToString:MEDIA_TYPE_PICTURE]) {
            // if picture was taken
            NSString *backgroundImageURL = mediaDictionary[MEDIA_TYPE][PICTURE_URL];
            [self.backgroundImage setImageWithURL:[NSURL URLWithString:backgroundImageURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
            
        } else if ([mediaDictionary[MEDIA_TYPE] isEqualToString:MEDIA_TYPE_VIDEO]) {
            // otherwise if video was recorded
            // TO DO: get image for picture
        }
    }
}

@end
