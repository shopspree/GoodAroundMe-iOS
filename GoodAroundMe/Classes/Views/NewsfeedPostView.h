//
//  NewsfeedPostView.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewsfeedView.h"
#import "UIImage+Resize.h"

#define NEWSFEED_POST_VIEW  100
#define NEWSFEED_POST_VIEW_THUMBNAIL_IMAGE          101
#define NEWSFEED_POST_VIEW_USERNAME_LABEL           102
#define NEWSFEED_POST_VIEW_TEAM_LABEL               103
#define NEWSFEED_POST_VIEW_TITLE_LABEL              104
#define NEWSFEED_POST_VIEW_IMAGE                    105
#define NEWSFEED_POST_VIEW_LIKES_COUNT_BUTTON       107
#define NEWSFEED_POST_VIEW_COMMENTS_COUNT_BUTTON    109
#define NEWSFEED_POST_VIEW_CONTENT_LABEL            110
#define NEWSFEED_POST_VIEW_LIKE_BUTTON              111
#define NEWSFEED_POST_VIEW_COMMENT_BUTTON           112
#define NEWSFEED_POST_VIEW_TIMESTAMP_LABEL          113

@interface NewsfeedPostView : NewsfeedView

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *mediaContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *captionView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *giveButon;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsCountButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *contributorLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

- (CGFloat)sizeToFitText:(NSString *)text;

@end
