//
//  UserSettingsViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserSettingsViewController.h"
#import "UIImage+Resize.h"
#import "AmazonAPI.h"
#import "SettingsViewController.h"

#define LOGOUT @"Log out"
#define ALERT_VIEW_TAG 666

@interface UserSettingsViewController () <UIAlertViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) SettingsViewController *settingsController;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UIView *settingsTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelNavButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneNavButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImage *userImage;

@end

@implementation UserSettingsViewController

- (void)viewDidLoad
{
    NSLog(@"[DEBUG] <UserSEttingsViewController> Started for user with attribtues: \nname: %@ %@ \nemail: %@ \nurl: %@ ", self.user.firstname, self.user.lastname, self.user.email, self.user.thumbnailURL);
    
    [super viewDidLoad];
    
    UITableViewController *settingsTable = [self.childViewControllers lastObject];
    settingsTable.tableView.delegate = self;
    settingsTable.tableView.backgroundView = nil;
    settingsTable.tableView.backgroundColor = [UIColor clearColor];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)refresh
{
    [self.userImageView setImageWithURL:[NSURL URLWithString:self.user.thumbnailURL]];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.userImageView.layer.cornerRadius = 10;
    self.userImageView.clipsToBounds = YES;
    
    self.userFullNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.firstname, self.user.lastname];
    
    self.userEmailLabel.text = self.user.email;
}

- (SettingsViewController *)settingsController
{
    if (!_settingsController) {
        _settingsController = [[SettingsViewController alloc] initWithController:self];
        _settingsController.imagePickerDelegate = self;
        _settingsController.amazonDelegate = self;
    }
    return _settingsController;
}

- (void)startActivityIndicationInNavigationBar
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = barButton;
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicationInNavigationBar
{
    [self.activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = self.doneNavButton;
}

- (void)updateUser
{
    NSLog(@"[DEBUG] <UserSEttingsViewController> Update user with attribtues: \nname: %@ %@ \nemail: %@ \nurl: %@ ", self.user.firstname, self.user.lastname, self.user.email, self.user.thumbnailURL);
    [self.user updateUser:^(User *user) {
        [self stopActivityIndicationInNavigationBar];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *message) {
        [self stopActivityIndicationInNavigationBar];
        [self fail:@"User preferences" withMessage:message];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.destinationViewController respondsToSelector:@selector(setUser:)]) {
        [segue.destinationViewController performSelector:@selector(setUser:) withObject:self.user];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:STORYBOARD_USER_EDIT_NAME sender:self];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        [self performSegueWithIdentifier:STORYBOARD_USER_CHANGE_PASSWORD sender:self];
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        [self signOut];
        
    } 
}


#pragma mark - Storyboard

- (IBAction)changeImageButtonAction:(id)sender
{
    [self.settingsController changeImage:self.view];
}

- (IBAction)done:(id)sender
{
    if (self.userImage) {
        [self startActivityIndicationInNavigationBar];
        [self.settingsController uploadtoAmazon:self.userImage bucket:self.user.email];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{ return; }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"[DEBUG] <UserSettingsViewController> AlertView %d clickedButtonAtIndex %d", alertView.tag, buttonIndex);
    if (alertView.tag == ALERT_VIEW_TAG && buttonIndex == 1) {
        [User signOut:^{
            [self navigateStoryboardWithIdentifier:STORYBOARD_LANDING_PAGE];
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
        
        // Save the new image (original or edited) to the Camera Roll
        if (editedImage != originalImage) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil , nil);
        }
        
        // scale image to screen size to improve performance
        image = [image scaleToSize:CGSizeMake(self.userImageView.frame.size.width, self.userImageView.frame.size.height)];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self changePicture:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

- (void)changePicture:(UIImage *)image
{
    self.userImage = image;
    [self.userImageView setImage:image];
}

- (void)editName
{
   [self performSegueWithIdentifier:STORYBOARD_USER_EDIT_NAME sender:self];
}

- (void)changePassword
{
    [self performSegueWithIdentifier:STORYBOARD_USER_CHANGE_PASSWORD sender:self];
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

#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@", request.requestTag, request.url);
    self.user.thumbnailURL = request.url.absoluteString;
    
    [self updateUser];
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSLog(@"[DEBUG] Request tag:%@ url:%@ %f%%!", request.requestTag, request.url, progress * 100);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@ Failed!", request.requestTag, request.url);
    [self stopActivityIndicationInNavigationBar];
}

@end
