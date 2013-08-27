//
//  UserSettingsViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <AWSS3/AWSS3.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "UserSettingsViewController.h"

#define CHANGE_PASSWORD @"Change password"
#define LOGOUT @"Log out"
#define ALERT_VIEW_TAG 666
#define ACTION_SHEET_CHANGE_PICTURE 12

@interface UserSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *userImageButton;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UIView *settingsTableView;


@end

@implementation UserSettingsViewController

- (void)setUser:(User *)user
{
    [super setUser:user];
    if (user) {
        //self.firstNameTextField.text = self.user.firstname;
        //self.lastNameTextField.text = self.user.lastname;
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

- (IBAction)changeImageButtonAction:(id)sender
{
    [self changeImage];
}

- (IBAction)imageButtonAction:(id)sender
{
    [self changeImage];
}


- (void)changeImage
{
    
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo options"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"From library", nil];
    cellActionSheet.tag = ACTION_SHEET_CHANGE_PICTURE;
    [cellActionSheet showInView:self.tableView];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_CHANGE_PICTURE) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
                
            case 1:
                [self choosePhotoFromLibrary];
                break;
                
            default:
                break;
        }
    }
}

- (void)takePhoto
{
    [self startImagePickerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera ];
}

- (void)choosePhotoFromLibrary
{
    [self startImagePickerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary ];
}

- (BOOL) startImagePickerFromViewController:(UIViewController*)controller
                              usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate
                                 sourceType:(UIImagePickerControllerSourceType)sourceType

{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        NSLog(@"[ERROR] Cannot access device camera");
        return NO;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;//UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or movie capture, if both are available:
    //cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures, or for trimming movies. To instead show the controls, use YES.
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = delegate;
    
    [controller presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"[DEBUG] Presenting device camera completed");
    }];
    
    return YES;
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *image;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        image = editedImage ? editedImage : originalImage;
        //self.imageView.image = image;
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);
    }
    
    // Handle a movie capture
    /*
     if (CFStringCompare ((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
     NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
     
     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
     UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
     }
     }
     */
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



@end
