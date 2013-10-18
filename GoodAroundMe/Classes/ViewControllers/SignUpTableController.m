//
//  SignUpTableController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/5/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "SignUpTableController.h"
#import "User+Create.h"

@interface SignUpTableController ()

@end

@implementation SignUpTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view

    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.firstNameTextField.tag = 1;
    self.lastNameTextField.tag = 2;
    self.emailTextField.tag = 3;
    self.passwordTextField.tag = 4;
    
    [self.firstNameTextField becomeFirstResponder];
}

@end
