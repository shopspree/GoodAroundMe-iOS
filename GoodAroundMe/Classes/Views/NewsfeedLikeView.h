//
//  NewsfeedLikeView.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedPostView.h"

@interface NewsfeedLikeView : NewsfeedView

@property (nonatomic, strong) Like *like;

- (void)populateViewWithNewsfeed:(Newsfeed *)newsfeed;

@end
