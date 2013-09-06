//
//  UserEditNameViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "UserEditNameViewController.h"
#import "User+Create.h"

#define FIRST_NAME_TAG    1
#define LAST_NAME_TAG     2

@interface UserEditNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@end

@implementation UserEditNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstNameTextField.tag = FIRST_NAME_TAG;
    if (self.firstNameTextField.text && ![self.firstNameTextField.text isEqual:@"(null)"])
        self.firstNameTextField.text = self.user.firstname;
    
    self.lastNameTextField.tag = LAST_NAME_TAG;
    if (self.lastNameTextField.text && ![self.lastNameTextField.text isEqual:@"(null)"])
        self.lastNameTextField.text = self.user.lastname;
}

- (void)doUserEditAction
{
    [self editName];
}

- (void)editName
{
    self.user.firstname = self.firstNameTextField.text;
    self.user.lastname = self.lastNameTextField.text;
    
    if ([self.firstNameTextField.text length] > 0 && [self.lastNameTextField.text length] > 0) {
        [self.user updateUser:^(User *user) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *message) {
            [self fail:@"Edit name" withMessage:message];
        }];
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
    if (indexPath.section == 1) {
        [self doUserEditAction];
    } else if (indexPath.section == 2) {
        [self cancel];
    }
}



@end
