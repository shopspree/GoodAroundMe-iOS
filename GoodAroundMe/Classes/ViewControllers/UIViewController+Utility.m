//
//  UIViewController+Utility.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/11/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UIViewController+Utility.h"

@implementation UIViewController (Utility)

- (void)fail:(NSString *)title withMessage:(NSString *)message
{
    if (title && message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
}

- (void)navigateStoryboardWithIdentifier:(NSString *)identifier
{
    UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:identifier];
    NSLog(@"[DEBUG] Navigate to %@", identifier);
    [self.navigationController pushViewController:obj animated:YES];
}


@end
