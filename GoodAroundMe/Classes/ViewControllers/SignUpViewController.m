//
//  SignUpViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/19/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "SignUpViewController.h"
#import "SignUpTableController.h"
#import "User+Create.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UIButton *signUpbutton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[self.childViewControllers lastObject] isKindOfClass:[SignUpTableController class]]) {
        SignUpTableController *signUpTableController = [self.childViewControllers lastObject];
        
        signUpTableController.firstNameTextField.delegate = self;
        signUpTableController.lastNameTextField.delegate = self;
        signUpTableController.emailTextField.delegate = self;
        signUpTableController.passwordTextField.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.activityIndicator.hidden = YES;
}

- (IBAction)signUpButtonAction:(id)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [self signUp];
}

- (IBAction)cancelButtonAction:(id)sender
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
    if ([[self.childViewControllers lastObject] isKindOfClass:[SignUpTableController class]]) {
        SignUpTableController *signUpTableController = [self.childViewControllers lastObject];
        
        if (textField.tag < 4) {
            [[signUpTableController.view viewWithTag:(textField.tag+1)] becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
            [self signUp];
        }
        
    }
    
    
    return YES;
}


#pragma mark - protected

- (void) signUp
{
    if ([[self.childViewControllers lastObject] isKindOfClass:[SignUpTableController class]]) {
        SignUpTableController *signUpTableController = [self.childViewControllers lastObject];
        
        NSString *firstName = signUpTableController.firstNameTextField.text;
        NSString *lastName = signUpTableController.lastNameTextField.text;
        NSString *email = signUpTableController.emailTextField.text;
        NSString *password = signUpTableController.passwordTextField.text;
        
        if (([self validateName:firstName]) &&
            ([self validateName:lastName]) &&
            ([self validateEmail:email]) &&
            ([self validatePassword:password])) {
            NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:email, USER_EMAIL, password, USER_PASSWORD, firstName, USER_FIRST_NAME, lastName, USER_LAST_NAME, nil], USER, nil];
            
            [User signUp:userDictionary success:^(User *user){
                [self.activityIndicator stopAnimating];
                [self navigateStoryboardWithIdentifier:EXPLORE];
            } failure:^(NSString *message) {
                [self.activityIndicator stopAnimating];
                [self fail:@"Sign up" withMessage:message];
            }];
        }
        
    }
}

- (BOOL)validateName:(NSString*)name
{
    if (![User validateName:name]) {
        [self fail:@"Authorization Error" withMessage:@"Enter valid name"];
        return NO;
    }
    
    return YES;
}

@end
