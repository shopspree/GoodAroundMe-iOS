//
//  UsersTableViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "User+Create.h"

@interface UsersTableViewController : CoreDataTableViewController

- (void)refresh;
- (void)setupFetchedResultsController;
- (User *)userForIndexPath:(NSIndexPath *)indexPath;

@end
