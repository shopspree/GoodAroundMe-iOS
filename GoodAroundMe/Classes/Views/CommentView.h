//
//  CommentView.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/24/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment+Create.h"

@interface CommentView : UIView

@property (strong, nonatomic) Comment *comment;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;

- (CGFloat)sizeToFitText:(NSString *)text;

@end
