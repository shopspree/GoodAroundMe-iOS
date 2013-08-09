//
//  AbstractViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractViewController : UIViewController <UIAlertViewDelegate>

- (void)fail:(NSString *)title withMessage:(NSString *)message;

@end
