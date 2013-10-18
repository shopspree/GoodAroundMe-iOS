//
//  UIViewController+Utility.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/11/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility)

- (void)fail:(NSString *)title withMessage:(NSString *)message;
- (void)info:(NSString *)title withMessage:(NSString *)message;
- (void)navigateStoryboardWithIdentifier:(NSString *)identifier;
- (NSString *)currentViewController;

@end
