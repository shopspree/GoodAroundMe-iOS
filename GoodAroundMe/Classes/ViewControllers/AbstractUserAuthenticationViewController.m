//
//  AbstractUserAuthenticationViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AbstractUserAuthenticationViewController.h"
#import "User+Create.h"

@interface AbstractUserAuthenticationViewController ()

@end

@implementation AbstractUserAuthenticationViewController

- (BOOL)validateEmail:(NSString*)email
{
    if (![User validateEmail:email]) {
        [self fail:@"Authorization Error" withMessage:@"Enter valid email address"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword:(NSString*)password
{
    if (![User validatePassword:password]) {
        [self fail:@"Authorization Error" withMessage:@"Illegal password"];
        return NO;
    }
    
    return YES;
}

- (void)authenticatedFirstTime:(BOOL)isInitialAuthentication
{
    NSString *identifier = (isInitialAuthentication) ? @"Explore" : @"Newsfeed";
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //[UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
    UITabBarController *obj=[storyboard instantiateViewControllerWithIdentifier:identifier];
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController pushViewController:obj animated:YES];
}

@end
