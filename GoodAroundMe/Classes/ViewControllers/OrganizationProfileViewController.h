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

@interface OrganizationProfileViewController : AbstractViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Organization *organization;

@end
