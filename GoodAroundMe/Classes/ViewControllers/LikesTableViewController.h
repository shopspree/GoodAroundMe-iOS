//
//  LikesTableViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Post+Create.h"

@interface LikesTableViewController : CoreDataTableViewController

@property (nonatomic, strong) Post *post;

@end
