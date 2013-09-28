//
//  CommentCell.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/23/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment+Create.h"
#import "CommentView.h"

// Fonts
extern NSString *const FontNameForCommentUserName;
extern NSString *const FontNameForCommentContent;
extern NSInteger const FontSizeForComment;

@protocol CommentCellDelegate <NSObject>

- (IBAction)commentTappedAction:(id)sender;

@end

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) Comment *comment;
@property (strong, nonatomic) CommentView *commentView;
@property (strong, nonatomic) id<CommentCellDelegate> delegate;

@end
