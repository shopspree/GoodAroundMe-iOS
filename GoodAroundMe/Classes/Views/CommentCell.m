//
//  CommentCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/23/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "CommentCell.h"
#import "User+Create.h"
#import "ApplicationHelper.h"

@implementation CommentCell

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    if (comment) {
        
        self.commentView = [[[NSBundle mainBundle] loadNibNamed:[[CommentView class] description] owner:nil options:nil] lastObject];
        
        self.commentView.frame = self.contentView.frame;
        self.commentView.tag = 500;
        [[self.contentView viewWithTag:500] removeFromSuperview];
        [self.contentView addSubview:self.commentView];
        self.commentView.comment = comment;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTappedAction:)];
        tap.numberOfTapsRequired = 1;
        self.commentView.tap = tap;
    }
}

- (IBAction)commentTappedAction:(id)sender
{
    [self.delegate commentTappedAction:sender];
}


@end
