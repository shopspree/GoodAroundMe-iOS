//
//  NotificationsTableViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/22/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+Create.h"

@interface NotificationsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) User *user;

@end
