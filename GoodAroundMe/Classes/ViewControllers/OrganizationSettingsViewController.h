//
//  OrganizationSettingsViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/6/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <AWSS3/AWSS3.h>
#import "AbstractViewController.h"
#import "Organization+Create.h"
#import "SettingsViewController.h"

@interface OrganizationSettingsViewController : AbstractViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate, AmazonServiceRequestDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) Organization *organization;
@property (nonatomic, strong) NSString *organizationName;
@property (nonatomic, strong) NSString *organizationLocation;
@property (nonatomic, strong) NSString *organizationAbout;
@property (nonatomic, strong) SettingsViewController *settingsController;

- (void)saveOrganization;
- (void)completion;
- (void)uploadImageToAmazon;

@end
