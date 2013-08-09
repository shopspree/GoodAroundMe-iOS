//
//  NewsfeedPostViewDelegate.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsfeedPostView.h"

@protocol NewsfeedPostViewDelegate <NSObject>

- (void)likeButtonClicked:(id)sender;
- (void)commentButtonClicked:(id)sender;
- (void)likesCountButtonClicked:(id)sender;
- (void)commentsCountButtonClicked:(id)sender;
- (void)usernameLabelTapped:(id)sender;
- (void)deleteButtonClicked:(id)sender;
- (void)moreButtonClicked:(id)sender;

@end
