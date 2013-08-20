//
//  DiscoverOrganizationCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DiscoverOrganizationCell.h"

@interface DiscoverOrganizationCell ()
@property (weak, nonatomic) IBOutlet UIButton *discoverOrganizationButton;

@end

@implementation DiscoverOrganizationCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.discoverOrganizationButton.clipsToBounds = YES;
    self.discoverOrganizationButton.layer.cornerRadius = 3;
}

@end
