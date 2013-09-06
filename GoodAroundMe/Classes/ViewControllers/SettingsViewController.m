//
//  SettingsViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/2/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "SettingsViewController.h"
#import "AmazonAPI.h"

#define ACTION_SHEET_CHANGE_PICTURE 12

@interface SettingsViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) UIViewController *controller;

@end

@implementation SettingsViewController

- (id)initWithController:(UIViewController *)controller
{
    self = [super init];
    self.controller = controller;
    
    return self;
}

- (void)takePhoto
{
    [self startImagePickerUsingDelegate:self.imagePickerDelegate sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)choosePhotoFromLibrary
{
    [self startImagePickerUsingDelegate:self.imagePickerDelegate sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) startImagePickerUsingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate
                            sourceType:(UIImagePickerControllerSourceType)sourceType

{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (self.controller == nil)) {
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
    
    [self.controller presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"[DEBUG] Presenting device camera completed");
    }];
    
    return YES;
}

- (void)uploadtoAmazon:(UIImage *)image bucket:(NSString *)bucketName
{
    AmazonAPI *api = [[AmazonAPI alloc] init];
    [api uploadImage:image toBucket:bucketName delegate:self.amazonDelegate];
}




- (void)changeImage:(UIView *)view
{
    
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo options"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"From library", nil];
    cellActionSheet.tag = ACTION_SHEET_CHANGE_PICTURE;
    [cellActionSheet showInView:view];
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

@end
