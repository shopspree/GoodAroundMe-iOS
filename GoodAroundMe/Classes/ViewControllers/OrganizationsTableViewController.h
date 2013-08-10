//
//  OrganizationsTableViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category+Create.h"
#import "CoreDataTableViewController.h"

@interface OrganizationsTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Category *category;

@end
