//
//  UserSettingsViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSS3/AWSS3.h>
#import "AbstractViewController.h"

@interface UserSettingsViewController : AbstractViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, AmazonServiceRequestDelegate>

@property (nonatomic, strong) User *user;

@end
