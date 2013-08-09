//
//  NewsfeedLikeView.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedLikeView.h"
#import "Newsfeed.h"
#import "Like.h"
#import "User.h"

@interface NewsfeedLikeView()

@property (nonatomic, strong) NSString *likerThumbnailURL;
@property (nonatomic, strong) NSString *likerUsernameText;

@property (weak, nonatomic) IBOutlet UIImageView *actorThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *actorNameAndActionLabel;
@property (weak, nonatomic) IBOutlet NewsfeedPostView *newsfeedPostView;

@end

@implementation NewsfeedLikeView

- (void)populateViewWithNewsfeed:(Newsfeed *)newsfeed
{
    if (newsfeed) {
        self.like = newsfeed.like;
        
        CGRect origFrame = self.newsfeedPostView.frame;
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NewsfeedPostView" owner:self options:nil];
        self.newsfeedPostView = [views lastObject];
        self.newsfeedPostView.post = newsfeed.like.post;
        [self addSubview:self.newsfeedPostView];
        self.newsfeedPostView.frame = origFrame;
    }
}

- (void)setLike:(Like *)like
{
    _like = like;
    if (like) {
        self.likerThumbnailURL = like.user.thumbnailURL;
        self.likerUsernameText = [NSString stringWithFormat:@"%@ %@", like.user.firstname, like.user.lastname];
    }
}

- (void)setLikerThumbnailURL:(NSString *)likerThumbnailURL
{
    _likerThumbnailURL = likerThumbnailURL;
    if (likerThumbnailURL) {
        [self.actorThumbnailImage setImageWithURL:[NSURL URLWithString:_likerThumbnailURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
    }
}

- (void)setLikerUsernameText:(NSString *)likerUsernameText
{
    _likerUsernameText = likerUsernameText;
    self.actorNameAndActionLabel.text = [NSString stringWithFormat:@"%@ liked a post", _likerUsernameText ? _likerUsernameText : @"John Doe"];
}


@end
