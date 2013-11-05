//
//  SignInResetPasswordViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 11/3/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AbstractUserAuthenticationViewController.h"

@interface SignInResetPasswordViewController : AbstractUserAuthenticationViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSString *email;

@end
