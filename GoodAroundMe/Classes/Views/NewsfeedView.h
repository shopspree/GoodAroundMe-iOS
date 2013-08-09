//
//  NewsfeedView.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationHelper.h"
#import "NewsfeedView.h"
#import "Newsfeed.h"

@interface NewsfeedView : UIView

- (void)populateViewWithNewsfeed:(Newsfeed *)newsfeed;

@end
