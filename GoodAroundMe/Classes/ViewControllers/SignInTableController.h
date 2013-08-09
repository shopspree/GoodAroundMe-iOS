//
//  SignInTableController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/6/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInTableController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
