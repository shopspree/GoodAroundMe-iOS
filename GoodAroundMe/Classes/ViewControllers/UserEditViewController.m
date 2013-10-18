//
//  UserEditViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/17/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UserEditViewController.h"

@interface UserEditViewController ()

@end

@implementation UserEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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

- (void)doUserEditAction
{
    // abstract method
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
        [self doUserEditAction];
    }
    
    return NO; // We do not want UITextField to insert line-breaks.
}

@end
