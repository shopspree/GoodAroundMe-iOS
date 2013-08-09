//
//  SignUpSignInViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/19/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "SignUpSignInViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "User+Create.h"

@interface SignUpSignInViewController ()

@end

@implementation SignUpSignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL]) {
        [self performSegueWithIdentifier:@"SignIn" sender:self];
    }
    
}

- (IBAction)signUpButtonAction:(id)sender
{
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}

- (IBAction)signInButtonAction:(id)sender
{
    [self performSegueWithIdentifier:@"SignIn" sender:self];
}

@end
