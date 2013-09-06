//
//  OrganizationProfileViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"
#import "Organization+Create.h" 
#import "NewsfeedPostViewDelegate.h"

@interface OrganizationProfileViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate, NewsfeedPostViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Organization *organization;

@end
