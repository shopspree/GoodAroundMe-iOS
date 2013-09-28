//
//  CommentView.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/24/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CommentView.h"
#import "User+Create.h"
#import "ApplicationHelper.h"

// Fonts
NSString *const FontNameForCommentUserName = @"GillSans";
NSString *const FontNameForCommentContent = @"GillSans-Light";
NSInteger const FontSizeForComment = 15.0f;

@implementation CommentView

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    [self userImage];
    [self content];
    [self timestamp];
}

- (void)userImage
{
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.comment.user.thumbnailURL]];
    self.userImageView.backgroundColor = [UIColor lightGrayColor];
}

- (void)content
{
    NSString *text = [self.comment getContentText];
    
    UIFont *nameFont = [UIFont fontWithName:FontNameForCommentUserName size:FontSizeForComment];
    UIFont *contentFont = [UIFont fontWithName:FontNameForCommentContent size:FontSizeForComment];
    
    // Create the attributes
    NSDictionary *nameAttrs = [NSDictionary dictionaryWithObjectsAndKeys: nameFont, NSFontAttributeName, nil];
    NSDictionary *contentAttrs = [NSDictionary dictionaryWithObjectsAndKeys: contentFont, NSFontAttributeName, nil];
    const NSRange range = NSMakeRange(0,[self.comment.user getFullName].length);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:contentAttrs];
    [attributedText setAttributes:nameAttrs range:range];
    
    // Set it in our UILabel and we are done!
    [self.contentLabel setAttributedText:attributedText];
    
}

- (void)timestamp
{
    self.timestampLabel.text = [ApplicationHelper timeSinceNow:self.comment.created_at];
}

- (CGFloat)sizeToFitText:(NSString *)text
{
    CGFloat height = self.frame.size.height;
    
    CGFloat originalLabelHeight = self.contentLabel.frame.size.height;
    CGSize labelSize = [text sizeWithFont:self.contentLabel.font
                        constrainedToSize:CGSizeMake(self.contentLabel.frame.size.width, 1000)
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat labelHeight = labelSize.height;
    CGFloat delta = (labelHeight - originalLabelHeight);
    
    height += (delta > 0) ? delta : 0;
    
    return height;
}

-(void)setTap:(UIGestureRecognizer *)tap
{
    [self.userImageView addGestureRecognizer:tap];
    self.userImageView.userInteractionEnabled = YES;
    
    [self.contentLabel addGestureRecognizer:tap];
    self.contentLabel.userInteractionEnabled = YES;
}

@end
