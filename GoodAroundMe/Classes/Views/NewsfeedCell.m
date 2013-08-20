//
//  NewsfeedCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedCell.h"
#import "NewsfeedView.h"

@implementation NewsfeedCell

- (void)setNewsfeed:(Newsfeed *)newsfeed
{
    _newsfeed = newsfeed;
    if (newsfeed) {
        
        NewsfeedView *newsfeedView = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Newsfeed%@View", newsfeed.type] owner:nil options:nil] lastObject];
        
        newsfeedView.tag = 500;
        [[self.contentView viewWithTag:500] removeFromSuperview];
        [self.contentView addSubview:newsfeedView];
        self.contentView.frame = newsfeedView.frame;
        [newsfeedView initWithNewsfeed:newsfeed];
    }
}

@end
