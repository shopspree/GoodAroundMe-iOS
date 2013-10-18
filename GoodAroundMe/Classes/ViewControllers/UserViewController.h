//
//  UserViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/17/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AbstractTableViewController.h"
#import "User+Create.h"

@interface UserViewController : AbstractTableViewController

@property (nonatomic, strong) User *user;

@end
