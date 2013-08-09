//
//  UserChangePasswordViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "UserChangePasswordViewController.h"
#import "User+Create.h"

#define CURRENT_PASSWORD_TAG    1
#define NEW_PASSWORD_TAG        2
#define CONFIRM_PASSWORD_TAG    3

@interface UserChangePasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;
@end

@implementation UserChangePasswordViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    [self animateTextField:textView up:YES];
}


- (void)keyboardWillHide:(UITextView *)textView
{
    [self animateTextField:textView up:NO];
}

- (void) animateTextField:(UITextView *)textView up:(BOOL)up
{
    const int movementDistance = 216.0; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration animations:^{
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                          self.tableView.frame.origin.y,
                                          self.tableView.frame.size.width,
                                          self.tableView.frame.size.height + movement);
    }];
}

#pragma mark - Storyboard

- (IBAction)changePasswordButtonClicked:(id)sender
{
    UITextField *currentPasswordTF = (UITextField *)[self.view viewWithTag:CURRENT_PASSWORD_TAG];
    UITextField *newPasswordTF = (UITextField *)[self.view viewWithTag:NEW_PASSWORD_TAG];
    UITextField *confirmPasswordTF = (UITextField *)[self.view viewWithTag:CONFIRM_PASSWORD_TAG];
    
    if ([currentPasswordTF.text length] > 0) {
        if ([newPasswordTF.text isEqualToString:confirmPasswordTF.text]) {
            [User changePassword:newPasswordTF.text confirmPassword:confirmPasswordTF.text currentPassword:currentPasswordTF.text success:^{
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSDictionary *errorData) {
                // TO DO pop up message to screen wrong current password
            }];
        } else {
            NSLog(@"[DEBUG] password do not match");
            // TO DO pop up message to screen password do not match
        }
    } else {
        NSLog(@"[DEBUG] current password is empty");
        // TO DO pop up message to screen wrong current password
    }
    
    


}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [self changePasswordButtonClicked:textField];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}



@end
