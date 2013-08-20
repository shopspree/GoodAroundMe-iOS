//
//  NewsfeedPostView.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewsfeedPostView.h"
#import "ApplicationHelper.h"
#import "NewsfeedPostViewDelegate.h"
#import "Organization.h"
#import "Post+Create.h"
#import "Picture.h"
#import "Like.h"
#import "CoreDataFactory.h"
#import "UIResponder+Helper.h"

@interface NewsfeedPostView()

@property (nonatomic, strong) Post *post;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
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

@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSString *nameText;
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, strong) NSString *pictureURL;
@property (nonatomic, strong) NSNumber *likesCountNumber;
@property (nonatomic, strong) NSNumber *commentsCountNumber;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSDate *timestampDate;
@property (nonatomic, strong) NSString *contributor;
@property (nonatomic) BOOL isLiked;

@end

@implementation NewsfeedPostView

- (void) initWithNewsfeed:(Newsfeed *)newsfeed
{
    if (newsfeed) {
        self.post = newsfeed.post;
    }
}

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        self.thumbnailURL = post.organization.image_thumbnail_url;
        self.nameText = post.organization.name;
        self.titleText = post.title;
        self.pictureURL = ((Picture *)[post.pictures anyObject]).url;
        self.likesCountNumber = post.likes_count;
        self.commentsCountNumber = post.comments_count;
        self.caption = post.caption;
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

- (void)setNameText:(NSString *)nameText
{
    _nameText = nameText;
    if (nameText) {
        self.nameLabel.text = _nameText;
        [self.nameLabel setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameLabelTapped:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [self.nameLabel addGestureRecognizer:tapGestureRecognizer];
    }
    
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

- (void)setCaption:(NSString *)caption
{
    _caption = caption;
    self.captionLabel.text = caption;
}

- (void)setTimestampDate:(NSDate *)timestampDate
{
    _timestampDate = timestampDate;
    self.timestampLabel.text = [ApplicationHelper timeSinceNow:timestampDate];
}

- (void)setContributor:(NSString *)contributor
{
    _contributor = contributor;
    self.contributorLabel.text = contributor ? [NSString stringWithFormat:@"By %@", contributor] : @"By unknown";
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
    self.likeButton.highlighted = isLiked;
    //[self.likeButton setTitle:@"Liked" forState:UIControlStateNormal];
}

- (IBAction)likeButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    [delegate likeButtonClicked:sender];
}

- (IBAction)commentButtonClicked:(id)sender
{
    id <NewsfeedPostViewDelegate> delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
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
