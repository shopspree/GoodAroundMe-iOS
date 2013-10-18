//
//  OrganizationCategoryViewController.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/7/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractViewController.h"

@interface OrganizationCategoryViewController : AbstractViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *categories;

@end
