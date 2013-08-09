//
//  SignInTableController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/6/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "SignInTableController.h"
#import "User+Create.h"

@interface SignInTableController ()

@end

@implementation SignInTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.emailTextField.tag = 1;
    self.passwordTextField.tag = 2;
    
    NSString *lastLoginEmail = [[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL];
    if (lastLoginEmail) {
        self.emailTextField.text = lastLoginEmail;
    } else {
        [self.emailTextField becomeFirstResponder];
    }
}


@end
