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
@property (strong, nonatomic) IBOutlet UIButton *backButton;
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
    self.backButton.userInteractionEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
    self.backButton.userInteractionEnabled = YES;
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
        email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *password = signInTableController.passwordTextField.text;

        if (([self validateEmail:email]) && ([self validatePassword:password])) {
            NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:email, USER_EMAIL,
                                            password, USER_PASSWORD, nil], USER_LOGIN, nil];
            
            self.logInButton.hidden = YES;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            
            [User signIn:userDictionary success:^(User *user) {
                self.logInButton.hidden = NO;
                NSLog(@"[DEBUG] <SignInViewController> Login success for user %@", user.email);
                [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(NSString *message) {
                [self fail:@"Login" withMessage:message];
                self.logInButton.hidden = NO;
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }];
        } 
    }
}





@end
