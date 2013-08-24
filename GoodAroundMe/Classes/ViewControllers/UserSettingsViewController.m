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

#define MY_SECRET_KEY @"Hg1vYx8K/+IcntjgTScefb4ox7TxRETuuQ+YKkF7"
#define MY_ACCESS_KEY_ID @"AKIAIYFCVLE2OKFN4FUQ"
#define MY_PICTURE_BUCKET @"goodaroundme/media"
#define MY_PICTURE_NAME @""

- (void)changeImage
{
    // TO DO!!!
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        [self uploadImage:image];
        
    }
}

- (void)uploadImage:(UIImage *)image
{
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
    
    NSString *s3BucketPath = [NSString stringWithFormat:@""];
    [s3 getBucketLocation:s3BucketPath];
    [s3 createBucket:[[S3CreateBucketRequest alloc] initWithName:s3BucketPath]];
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:MY_PICTURE_NAME inBucket:MY_PICTURE_BUCKET];
    por.contentType = @"image/jpeg";
    //por.data = imageData;
    por.cannedACL = [S3CannedACL publicRead];
    [s3 putObject:por];
    
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key     = MY_PICTURE_NAME;
    gpsur.bucket  = MY_PICTURE_BUCKET;
    gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
    gpsur.responseHeaderOverrides = override;
    NSURL *url = [s3 getPreSignedURL:gpsur];
    [[UIApplication sharedApplication] openURL:url];
}



@end
