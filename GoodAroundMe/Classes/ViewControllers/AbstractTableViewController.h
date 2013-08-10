//
//  AbstractTableViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractTableViewController : UITableViewController

- (void)fail:(NSString *)title withMessage:(NSString *)message;

@end
