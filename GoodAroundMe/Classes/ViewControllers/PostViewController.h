//
//  NewsfeedViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/9/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "Post+Create.h"
#import "NewsfeedPostViewDelegate.h"


@interface PostViewController : AbstractViewController <NewsfeedPostViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Post *post;
@property (nonatomic) BOOL keyboardIsShown;

@end
