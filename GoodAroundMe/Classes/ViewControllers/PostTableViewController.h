//
//  PostTableViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/9/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "Post+Create.h"    

@interface PostTableViewController : CoreDataTableViewController <UIActionSheetDelegate>

@property (nonatomic, strong) UIViewController *masterController;
@property (nonatomic, strong) Post *post;

@end
