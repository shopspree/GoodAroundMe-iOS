//
//  AbstractViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryboardConstants.h"
#import "UIViewController+Utility.h"
#import "User+Create.h"
#import "GAITrackedViewController.h"

@interface AbstractViewController : GAITrackedViewController <UIAlertViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// For Google iOS Analytics
//@property (strong, nonatomic) NSString *trackedViewName;

@end
