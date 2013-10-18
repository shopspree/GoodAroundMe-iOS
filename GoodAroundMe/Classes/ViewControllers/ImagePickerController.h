//
//  ImagePickerController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImagePickerController : NSObject <UIAlertViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIViewController *controller;

@end
