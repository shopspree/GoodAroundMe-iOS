//
//  UserSettingsViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UserSettingsViewController.h"

#define CHANGE_PASSWORD @"Change password"
#define LOGOUT @"Log out"
#define ALERT_VIEW_TAG 666

@interface UserSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;

@end

@implementation UserSettingsViewController

- (void)setUser:(User *)user
{
    [super setUser:user];
    if (user) {
        self.firstNameTextField.text = self.user.firstname;
        self.lastNameTextField.text = self.user.lastname;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)signOut
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Sign out", nil];
    alert.tag = ALERT_VIEW_TAG;
    [alert show];
}

- (void)changeImage
{
    // TO DO!!!
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentModalViewController:imagePicker animated:YES];
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY] autorelease];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:EDIT_NAME sender:self];
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        [self performSegueWithIdentifier:CHANGE_PASSWORD sender:self];
        
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        [self signOut];
    }
}


#pragma mark - Storyboard

- (IBAction)imageAction:(id)sender
{
    [self changeImage];
}

- (IBAction)changeImageAction:(id)sender
{
    [self changeImage];
}

- (IBAction)doneButtonAction:(id)sender
{
    NSDictionary *userDictionary = [NSDictionary dictionary];
    [self.user updateUser:userDictionary success:^(User *user) {
        [self dismissViewControllerAnimated:YES completion:^{ return; }];
    } failure:^(NSString *message) {
        [self fail:@"User preferences" withMessage:message];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALERT_VIEW_TAG && buttonIndex == 0) {
        [User signOut:^{
            [self navigateStoryboardWithIdentifier:SIGNUP_SIGNIN];
        } failure:^(NSString *message) {
            [self fail:@"Sign out failed" withMessage:message];
        }];
    }
}

@end
