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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
}

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

@end
