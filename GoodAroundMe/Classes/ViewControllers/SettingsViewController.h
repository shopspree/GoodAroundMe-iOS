//
//  SettingsViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/2/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <AWSS3/AWSS3.h>
#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController 

@property (nonatomic, strong) id <UIImagePickerControllerDelegate, UINavigationControllerDelegate> imagePickerDelegate;
@property (nonatomic, strong) id<AmazonServiceRequestDelegate> amazonDelegate;

- (id)initWithController:(UIViewController *)controller;
- (void)takePhoto;
- (void)choosePhotoFromLibrary;
- (void)uploadtoAmazon:(UIImage *)image bucket:(NSString *)bucketNamedelegate;
- (void)changeImage:(UIView *)view;

@end
