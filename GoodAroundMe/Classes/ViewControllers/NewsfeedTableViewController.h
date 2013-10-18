//
//  NewsfeedsTableViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "NewsfeedPostViewDelegate.h"

@interface NewsfeedTableViewController : CoreDataTableViewController <NewsfeedPostViewDelegate, UIActionSheetDelegate>

@end
