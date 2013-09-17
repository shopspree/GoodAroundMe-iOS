//
//  OrganizationCell.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization.h"

@interface OrganizationCell : UITableViewCell

@property (nonatomic, strong) Organization *organization;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end
