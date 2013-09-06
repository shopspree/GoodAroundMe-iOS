//
//  CommentCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/9/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CommentCell.h"
#import "User.h"
#import "ApplicationHelper.h"

@interface CommentCell()

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *timestamp;

@end

@implementation CommentCell

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    if (comment) {
        NSLog(@"[DEBUG] <CommentCell> Comment user is %@ %@ %@", comment.user.firstname, comment.user.lastname, comment.user.thumbnailURL);
        self.imageURL = comment.user.thumbnailURL;
        self.username = [NSString stringWithFormat:@"%@ %@", comment.user.firstname, comment.user.lastname];
        self.content = comment.content;
        self.timestamp = [ApplicationHelper timeSinceNow:comment.created_at];
        
    }
}

- (void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    //self.thumbnailImage.frame = CGRectMake(10, 5, 50, 50);
    [self.thumbnailImage setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    self.usernameLabel.text = username;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.contentLabel.text = content;
}

- (void)setTimestamp:(NSString *)timestamp
{
    _timestamp = timestamp;
    self.timestampLabel.text = timestamp;
}

- (void)layoutSubviews
{
    self.contentLabel.frame = CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, 237, 21); // TO DO: how to avoid hard coding ?!
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping]; //will wrap text in new line
    [self.contentLabel sizeToFit];
}

@end
