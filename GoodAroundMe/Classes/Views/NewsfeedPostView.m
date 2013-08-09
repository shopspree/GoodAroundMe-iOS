//
//  NewsfeedPostView.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedPostView.h"
#import "NewsfeedPostViewDelegate.h"
#import "User.h"
#import "Post+Create.h"
#import "Picture.h"
#import "Like.h"
#import "CoreDataFactory.h"
#import "UIResponder+Helper.h"

@interface NewsfeedPostView()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *likesCountButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsCountButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *usernameText;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSNumber *likesCountNumber;
@property (nonatomic, strong) NSNumber *commentsCountNumber;
@property (nonatomic, strong) NSString *descrtiptionText;
@property (nonatomic, strong) NSDate *timestampDate;
@property (nonatomic) BOOL isLiked;

@end

@implementation NewsfeedPostView

- (void)populateViewWithNewsfeed:(Newsfeed *)newsfeed
{
    if (newsfeed) {
        NSLog(@"[DEBUG] populateViewWithNewsfeed uid=%@", newsfeed.post? newsfeed.post.uid : newsfeed.like.post.uid);
        self.post = newsfeed.post;
    }
}

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        self.thumbnailURL = post.user.thumbnailURL;
        self.usernameText = [NSString stringWithFormat:@"%@ %@", post.user.firstname, post.user.lastname];
        self.titleText = post.uid;
        self.pictureURL = [self pictureURLFromPictures:post.pictures];
        self.likesCountNumber = post.likes_count;
        self.commentsCountNumber = post.comments_count;
        self.descrtiptionText = post.content;
        self.timestampDate = post.created_at;
        self.isLiked = [post.liked_by_user boolValue];
    }
    
    [self setup];
}

- (void)setup
{
    self.commentButton.tag = NEWSFEED_POST_VIEW_COMMENT_BUTTON;
}

- (void)setThumbnailURL:(NSString *)thumbnailURL
{
    _thumbnailURL = thumbnailURL;
    if (thumbnailURL) {
        [self.thumbnailImage setImageWithURL:[NSURL URLWithString:_thumbnailURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
    }
}

- (void)setUsernameText:(NSString *)usernameText
{
    _usernameText = usernameText;
    self.usernameLabel.text = _usernameText ? _usernameText : @"John Doe";
    [self.usernameLabel setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameLabelTapped:)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [self.usernameLabel addGestureRecognizer:tapGestureRecognizer];
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setPictureURL:(NSString *)pictureURL
{
    _pictureURL = pictureURL;
    if (pictureURL) {
        [self.pictureImage setImageWithURL:[NSURL URLWithString:_pictureURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
    }
}

- (void)setLikesCountNumber:(NSNumber *)likesCountNumber
{
    _likesCountNumber = likesCountNumber;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self likesCountWithNumber:likesCountNumber]];
    [self.likesCountButton setAttributedTitle:string
                                     forState:UIControlStateNormal];
    self.likesCountButton.tag = NEWSFEED_POST_VIEW_LIKES_COUNT_BUTTON;
}

- (void)setCommentsCountNumber:(NSNumber *)commentsCountNumber
{
    _commentsCountNumber = commentsCountNumber;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self commentsCountWithNumber:commentsCountNumber]];
    [self.commentsCountButton setAttributedTitle:string
                                     forState:UIControlStateNormal];
    self.commentsCountButton.tag = NEWSFEED_POST_VIEW_COMMENTS_COUNT_BUTTON;
}

- (void)setDescrtiptionText:(NSString *)descrtiptionText
{
    _descrtiptionText = descrtiptionText;
    self.descriptionLabel.text = descrtiptionText;
}

- (void)setTimestampDate:(NSDate *)timestampDate
{
    _timestampDate = timestampDate;
    self.timestampLabel.text = [ApplicationHelper timeSinceNow:timestampDate];
}

- (NSString *)pictureURLFromPictures:(NSSet *)pictures
{
    for (Picture *picture in pictures) {
        if (picture) {
            NSLog(@"Picture url:%@ uid:%@", picture.url, picture.uid);
            return picture.url;
        }
    }
    
    return nil;
}

- (NSString *)likesCountWithNumber:(NSNumber *)count
{
    NSString *likesCount; 
    switch ([count integerValue]) {
        case 0:
            likesCount = @"";
            [self.likesCountButton setUserInteractionEnabled:NO];
            break;
        case 1:
            likesCount = @"1 like";
            [self.likesCountButton setUserInteractionEnabled:YES];
            break;
        default:
            likesCount = [NSString stringWithFormat:@"%@ likes", count];
            [self.likesCountButton setUserInteractionEnabled:YES];
            break;
    }
    return likesCount;
}

- (NSString *)commentsCountWithNumber:(NSNumber *)count
{
    NSString *commentsCount;
    switch ([count integerValue]) {
        case 0:
            commentsCount = @"";
            [self.commentsCountButton setUserInteractionEnabled:NO];
            break;
        case 1:
            commentsCount = @"1 comment";
            [self.commentsCountButton setUserInteractionEnabled:YES];
        default:
            commentsCount = [NSString stringWithFormat:@"%@ comments", count];
            [self.commentsCountButton setUserInteractionEnabled:YES];
            break;
    }
    return commentsCount;
}

- (void)setIsLiked:(BOOL)isLiked
{
    _isLiked = isLiked;
    if (isLiked) {
        [self.likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
        NSLog(@"like button title is %@", self.likeButton.titleLabel.text);
    }
}

- (IBAction)likeButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate likeButtonClicked:sender];
}

- (IBAction)commentButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    NSLog(@"commentButton tag = %d", self.commentButton.tag);
    [delegate commentButtonClicked:sender];
}

- (IBAction)likesCountButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate likesCountButtonClicked:sender];
}

- (IBAction)commentsCounButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate commentsCountButtonClicked:sender];
}

- (void)usernameLabelTapped:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate usernameLabelTapped:sender];
}

- (IBAction)deleteButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate deleteButtonClicked:sender];
}

- (IBAction)moreButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate moreButtonClicked:sender];
}

@end
