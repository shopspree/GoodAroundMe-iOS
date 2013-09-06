//
//  NewsfeedCell.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Newsfeed.h"
#import "NewsfeedView.h"

@interface NewsfeedCell : UITableViewCell

@property (nonatomic, strong) Newsfeed *newsfeed;
@property (nonatomic, strong) NewsfeedView *newsfeedView;

@end
