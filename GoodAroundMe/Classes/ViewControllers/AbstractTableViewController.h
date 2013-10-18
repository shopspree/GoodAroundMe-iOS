//
//  AbstractTableViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/11/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Utility.h"
#import "StoryboardConstants.h"
#import "GAITrackedViewController.h"

@interface AbstractTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)startActivityIndicationInNavigationBar;
- (void)stopActivityIndicationInNavigationBar;

@end
