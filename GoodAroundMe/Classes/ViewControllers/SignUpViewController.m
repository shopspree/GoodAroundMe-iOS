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
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
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
    
    self.errorLabel.hidden = YES;
}

- (IBAction)signUpButtonAction:(id)sender
{
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
            NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:email, USER_EMAIL,
                                            password, USER_PASSWORD, nil], @"user", nil];
            
            [User signUp:userDictionary success:^{
                [self authenticatedFirstTime:YES];
            } failure:^(NSDictionary *errorData) {
                NSString *messageTopic = [[errorData[@"errors"] allKeys] lastObject];
                NSString *messageContent = [[errorData[@"errors"] allValues] lastObject][0];
                NSString *message = [NSString stringWithFormat:@"%@ %@", messageTopic, messageContent];
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
