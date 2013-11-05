//
//  SignInResetPasswordViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 11/3/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "SignInResetPasswordViewController.h"

@interface SignInResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SignInResetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.emailTextField.delegate = self;
    
    self.activityIndicator.hidden = YES;
    [self.activityIndicator hidesWhenStopped];
    [self.activityIndicator stopAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.emailTextField.text = self.email;
}

#pragma mark - private

- (void)startActivityIndicator
{
    self.resetPasswordButton.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicator
{
    self.resetPasswordButton.hidden = NO;
    [self.activityIndicator stopAnimating];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetPassword:self];
    
    return YES;
}

#pragma mark - storyboard

- (IBAction)resetPassword:(id)sender
{
    NSString *email = self.emailTextField.text;
    if (!email) {
        return;
    }
    
    [self startActivityIndicator];
    
    [User resetPasswordForEmail:email success:^{
        [self info:@"Reset Password Successful" withMessage:@"Reset pasaword instructions sent successfully. Please check your email"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *message) {
        [self stopActivityIndicator];
        [self fail:@"Reset Password Failed" withMessage:message];
    }];
    
}

- (IBAction)backButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
