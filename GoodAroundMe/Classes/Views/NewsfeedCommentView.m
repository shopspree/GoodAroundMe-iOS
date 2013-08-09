//
//  NewsfeedLikeView.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedCommentView.h"
#import "Newsfeed.h"
#import "Comment.h"
#import "User.h"

@interface NewsfeedCommentView()

@property (nonatomic, strong) NSString *commentatorThumbnailURL;
@property (nonatomic, strong) NSString *commentatorUsernameText;

@property (weak, nonatomic) IBOutlet UIImageView *actorThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *actorNameAndActionLabel;
@property (weak, nonatomic) IBOutlet NewsfeedPostView *newsfeedPostView;

@end

@implementation NewsfeedCommentView

- (void)populateViewWithNewsfeed:(Newsfeed *)newsfeed
{
    if (newsfeed) {
        self.comment = newsfeed.comment;
        
        CGRect origFrame = self.newsfeedPostView.frame;
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NewsfeedPostView" owner:self options:nil];
        self.newsfeedPostView = [views lastObject];
        self.newsfeedPostView.post = newsfeed.comment.post;
        [self addSubview:self.newsfeedPostView];
        self.newsfeedPostView.frame = origFrame;
    }
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    if (comment) {
        self.commentatorThumbnailURL = comment.user.thumbnailURL;
        self.commentatorUsernameText = [NSString stringWithFormat:@"%@ %@", comment.user.firstname, comment.user.lastname];
    }
}

- (void)setCommentatorThumbnailURL:(NSString *)commentatorThumbnailURL
{
    _commentatorThumbnailURL = commentatorThumbnailURL;
    if (commentatorThumbnailURL) {
        [self.actorThumbnailImage setImageWithURL:[NSURL URLWithString:_commentatorThumbnailURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
    }
}

- (void)setCommentatorUsernameText:(NSString *)commentatorUsernameText
{
    _commentatorUsernameText = commentatorUsernameText;
    self.actorNameAndActionLabel.text = [NSString stringWithFormat:@"%@ commented on a post", _commentatorUsernameText ? _commentatorUsernameText : @"John Doe"];
}

@end
