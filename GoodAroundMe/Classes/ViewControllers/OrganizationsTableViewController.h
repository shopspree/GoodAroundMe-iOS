//
//  OrganizationsTableViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User+Create.h"
#import "OrganizationCategory+Create.h"
#import "CoreDataTableViewController.h"

@interface OrganizationsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) OrganizationCategory *category;

@end
