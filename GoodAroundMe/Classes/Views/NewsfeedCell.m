//
//  NewsfeedCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedCell.h"

@implementation NewsfeedCell

- (void)setNewsfeed:(Newsfeed *)newsfeed
{
    _newsfeed = newsfeed;
    if (newsfeed) {
        
        self.newsfeedView = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Newsfeed%@View", newsfeed.type] owner:nil options:nil] lastObject];
        
        self.newsfeedView.tag = 500;
        [[self.contentView viewWithTag:500] removeFromSuperview];
        [self.contentView addSubview:self.newsfeedView];
        self.contentView.frame = self.newsfeedView.frame;
        [self.newsfeedView initWithNewsfeed:newsfeed];
    }
}

@end
