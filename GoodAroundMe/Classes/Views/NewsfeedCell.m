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
        
        NewsfeedView *view = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Newsfeed%@View", newsfeed.type] owner:nil options:nil] lastObject];
        
        view.tag = 500;
        [[self.contentView viewWithTag:500] removeFromSuperview];
        [self.contentView addSubview:view];
        self.contentView.frame = view.frame;
        [view populateViewWithNewsfeed:newsfeed];
    }
}

@end
