//
//  FollowersTableViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UsersTableViewController.h"
#import "Organization+Create.h"

@interface FollowersTableViewController : UsersTableViewController

@property (nonatomic, strong) Organization *organization;

@end
