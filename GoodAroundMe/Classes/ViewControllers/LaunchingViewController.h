//
//  LaunchingViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/17/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AbstractViewController.h"
#import "User+Create.h"

@interface LaunchingViewController : AbstractViewController

- (IBAction)unwindFromUserAuthentication:(UIStoryboardSegue *)segue;

@end
