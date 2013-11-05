//
//  NewsfeedPostView.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewsfeedPostView.h"
#import "ApplicationHelper.h"
#import "NewsfeedPostViewDelegate.h"
#import "Organization.h"
#import "Post+Create.h"
#import "Photo+Create.h"
#import "Video.h"
#import "User+Create.h"
#import "Like.h"
#import "CoreDataFactory.h"
#import "UIResponder+Helper.h"
#import "AppConstants.h"
#import "ApplicationDictionary.h"

@interface NewsfeedPostView()

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) id <NewsfeedPostViewDelegate> delegate;

@end

@implementation NewsfeedPostView

- (void) initWithNewsfeed:(Newsfeed *)newsfeed
{
    if (newsfeed) {
        self.post = newsfeed.post;
    }
    
}

- (id<NewsfeedPostViewDelegate>)delegate
{
    if (!_delegate) {
        _delegate = [self traverseResponderChainForProtocol:@protocol(NewsfeedPostViewDelegate)];
    }
    return _delegate;
}

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        Media *media = [[post.medias allObjects] lastObject];
        self.imageURL = media.image_url;
        self.thumbnailURL = post.organization.image_thumbnail_url;
        self.nameText = post.organization.name;
        self.titleText = post.title;
        self.contributor = post.contributor;
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
    
    ApplicationDictionary *applicationDictionary = [ApplicationDictionary sharedInstance];
    BOOL giveButtonEnabled = [[applicationDictionary.dictionary objectForKey:DictionaryGiveEnabled] isEqualToString:@"true"];
    self.giveButon.enabled = giveButtonEnabled;
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    /*
    [self addObserver:self.post
           forKeyPath:@"comments_count"
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    [self addObserver:self.post
           forKeyPath:@"likes_count"
              options:NSKeyValueObservingOptionNew
              context:nil]; */
}

- (void)setThumbnailURL:(NSString *)thumbnailURL
{
    [super setThumbnailURL:thumbnailURL];
    if (thumbnailURL) {
        [self.logoImage setImageWithURL:[NSURL URLWithString:thumbnailURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        self.logoImage.image = [self.logoImage.image scaleToSize:self.logoImage.frame.size];
        self.logoImage.tag = NEWSFEED_POST_VIEW_THUMBNAIL_IMAGE;
        self.logoImage.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapGesture.numberOfTapsRequired = 1;
        [self.logoImage addGestureRecognizer:tapGesture];
    }
}

- (void)setNameText:(NSString *)nameText
{
    [super setNameText:nameText];
    if (nameText) {
        [self.nameButton setTitle:nameText forState:UIControlStateNormal];
        self.nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.nameButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        UIFont *font = self.nameButton.titleLabel.font;
        CGSize stringsize = [nameText sizeWithFont:font];
        
        CGRect buttonFrame = self.nameButton.frame;
        self.nameButton.frame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, stringsize.width, buttonFrame.size.height);
    }
    
}

- (void)setTitleText:(NSString *)titleText
{
    [super setTitleText:titleText];
    self.titleLabel.text = titleText;
}

- (void)setImageURL:(NSString *)imageURL
{
    if (imageURL) {
        [self.imageView setImageWithURL:[NSURL URLWithString:imageURL]];
        self.imageView.image = [self.imageView.image scaleToSize:self.imageView.frame.size];
        self.imageView.tag = NEWSFEED_POST_VIEW_IMAGE;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.backgroundColor = [UIColor lightGrayColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapGesture.numberOfTapsRequired = 1;
        [self.imageView addGestureRecognizer:tapGesture];
        
    }
    
    [super setImageURL:imageURL];
}

- (void)setLikesCountNumber:(NSNumber *)likesCountNumber
{
    [super setLikesCountNumber:likesCountNumber];
    NSString *count = [likesCountNumber description];
    [self.likesCountButton setTitle:count forState:UIControlStateNormal];
    self.likesCountButton.tag = NEWSFEED_POST_VIEW_LIKES_COUNT_BUTTON;
}

- (void)setCommentsCountNumber:(NSNumber *)commentsCountNumber
{
    [super setCommentsCountNumber:commentsCountNumber];
    NSString *count = [commentsCountNumber description];
    [self.commentsCountButton setTitle:count forState:UIControlStateNormal];
    self.commentsCountButton.tag = NEWSFEED_POST_VIEW_COMMENTS_COUNT_BUTTON;
}

- (void)setCaption:(NSString *)caption
{
    [super setCaption:caption];
    self.captionLabel.text = caption;
}

- (void)setTimestampDate:(NSDate *)timestampDate
{
    [super setTimestampDate:timestampDate];
    self.timestampLabel.text = [ApplicationHelper timeSinceNow:timestampDate];
}

- (void)setContributor:(NSString *)contributor
{
    [super setContributor:contributor];
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
    [super setIsLiked:isLiked];
    self.likeButton.highlighted = isLiked;
}

#pragma mark - Storyboard

- (IBAction)tap:(id)sender
{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapGesture locationInView:self];
    UIView *senderView = [self hitTest:point withEvent:nil];
    
    switch (senderView.tag) {
        case NEWSFEED_POST_VIEW_THUMBNAIL_IMAGE:
            [self logoAction:senderView];
            break;
            
        case NEWSFEED_POST_VIEW_IMAGE:
            [self pictureAction:senderView];
            break;
            
        default:
            break;
    }
}


- (IBAction)logoAction:(id)sender
{
    [self.delegate tapOnOrganization:sender];
}

- (IBAction)nameAction:(id)sender
{
    [self.delegate tapOnOrganization:sender];
}

- (IBAction)pictureAction:(id)sender
{
    
    [self.delegate tapOnPost:sender];
}

- (IBAction)likeButtonClicked:(id)sender
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.delegate likePost:sender];
}

- (IBAction)commentButtonClicked:(id)sender
{
    [self.delegate commentOnPost:sender];
}

- (IBAction)likesCountButtonClicked:(id)sender
{
    [self.delegate likesOnPost:sender];
}

- (IBAction)commentsCounButtonClicked:(id)sender
{
    [self.delegate tapOnPost:sender];
}

- (IBAction)deleteButtonClicked:(id)sender
{
    [self.delegate deletePost:sender];
}

- (IBAction)moreButtonClicked:(id)sender
{
    [self.delegate tapOnPost:sender];
}

- (IBAction)giveButtonAction:(id)sender
{
    [self.delegate give:sender];
}

- (CGFloat)sizeToFitText:(NSString *)text
{
    CGFloat height = self.frame.size.height;

    CGFloat originalLabelHeight = self.captionLabel.frame.size.height;

    CGSize labelSize = [text sizeWithFont:self.captionLabel.font
                        constrainedToSize:CGSizeMake(self.captionLabel.bounds.size.width, 1000)
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat labelHeight = labelSize.height;
    CGFloat delta = (labelHeight - originalLabelHeight);
    
    height += delta;
    
    return height;
}

@end
