//
//  ImagePickerController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "ImagePickerController.h"

@implementation ImagePickerController

- (void)takePhoto
{
    [self startImagePickerFromViewController:self.controller usingDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera ];
}

- (void)choosePhotoFromLibrary
{
    [self startImagePickerFromViewController:self.controller usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary ];
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
