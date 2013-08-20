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

@interface UserChangePasswordViewController () 
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmedPasswordTextField;

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
    
    self.currentPasswordTextField.tag = CURRENT_PASSWORD_TAG;
    self.passwordTextField.tag = NEW_PASSWORD_TAG;
    self.confirmedPasswordTextField.tag = CONFIRM_PASSWORD_TAG;
}

- (void)doUserEditAction
{
    [self changePassword];
}

- (void)changePassword
{
    if ([self.currentPasswordTextField.text length] > 0) {
        if ([self.passwordTextField.text isEqualToString:self.confirmedPasswordTextField.text]) {
            [self.user changePassword:self.passwordTextField.text confirmPassword:self.confirmedPasswordTextField.text currentPassword:self.currentPasswordTextField.text success:^{
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSString *message) {
                [self fail:@"Change password" withMessage:message];
            }];
        } else {
            NSLog(@"[DEBUG] password do not match");
            [self fail:@"Change password" withMessage:@"Confirmed password do no match"];
        }
    } else {
        NSLog(@"[DEBUG] current password is empty");
        [self fail:@"Change password" withMessage:@"Current password is empty"];
    }
}

- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self changePassword];
    } else if (indexPath.section == 3) {
        [self cancel];
    }
}



@end
