//
//  OrganizationAboutCell.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationAboutView.h"

@interface OrganizationAboutCell : UITableViewCell

@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) OrganizationAboutView *aboutView;

@end
