//
//  NewsfeedView.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Newsfeed.h"

@interface NewsfeedView : UIView

@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *nameText;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSNumber *likesCountNumber;
@property (nonatomic, strong) NSNumber *commentsCountNumber;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSDate *timestampDate;
@property (nonatomic, strong) NSString *contributor;
@property (nonatomic) BOOL isLiked;

- (void) initWithNewsfeed:(Newsfeed *)newsfeed;

@end
