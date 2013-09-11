//
//  SignInViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/19/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "SignInViewController.h"
#import "SignInTableController.h"
#import "User+Create.h"

@interface SignInViewController ()

@property (strong, nonatomic) IBOutlet UIButton *logInButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activityIndicator.hidden = YES;
    
    if ([[self.childViewControllers lastObject] isKindOfClass:[SignInTableController class]]) {
        SignInTableController *signInTableController= [self.childViewControllers lastObject];
        
        signInTableController.emailTextField.delegate = self;
        signInTableController.passwordTextField.delegate = self;
    }
    
	// Do any additional setup after loading the view.
}

- (IBAction)logInButtonClicked:(id)sender 
{
    [self.view endEditing:YES];
    
    [self signIn];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapBackground:(id)sender
{
    [self.view endEditing:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1) {
        [[self.view viewWithTag:(textField.tag+1)] becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self signIn];
    }
    
    return YES;
}


#pragma mark - protected

- (void)signIn
{
    if ([[self.childViewControllers lastObject] isKindOfClass:[SignInTableController class]]) {
        SignInTableController *signInTableController= [self.childViewControllers lastObject];
        
        NSString *email = signInTableController.emailTextField.text;
        NSString *password = signInTableController.passwordTextField.text;

        if (([self validateEmail:email]) && ([self validatePassword:password])) {
            NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:email, USER_EMAIL,
                                            password, USER_PASSWORD, nil], USER_LOGIN, nil];
            
            self.logInButton.hidden = YES;
            [self.activityIndicator startAnimating];
            
            [User signIn:userDictionary success:^(User *user) {
                NSString *identifier =  STORYBOARD_LANDING_PAGE;
                [self navigateStoryboardWithIdentifier:identifier];
            } failure:^(NSDictionary *errorData) {
                [self fail:@"Login" withMessage:errorData[@"errors"]];
                self.logInButton.hidden = NO;
                
                self.logInButton.hidden = YES;
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }];
        } 
    }
}





@end
