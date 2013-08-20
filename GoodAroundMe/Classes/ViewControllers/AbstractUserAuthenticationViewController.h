//
//  AbstractUserAuthenticationViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "StoryboardConstants.h"

@interface AbstractUserAuthenticationViewController : AbstractViewController

- (BOOL)validateEmail:(NSString*)email;
- (BOOL)validatePassword:(NSString*)password;

@end
