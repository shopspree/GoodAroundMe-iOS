//
//  NewsfeedCommentView.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedPostView.h"

@interface NewsfeedCommentView : NewsfeedView

@property (nonatomic, strong) Comment *comment;

- (void)populateViewWithNewsfeed:(Newsfeed *)newsfeed;

@end
