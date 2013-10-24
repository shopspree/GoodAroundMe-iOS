//
//  OrganizationAboutCell.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "OrganizationAboutCell.h"

@interface OrganizationAboutCell ()

@end

@implementation OrganizationAboutCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    self.aboutView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.aboutView];
    
    self.aboutView.aboutTextView.text = self.about;
}

- (OrganizationAboutView *)aboutView
{
    if (!_aboutView) {
        _aboutView = [[[NSBundle mainBundle] loadNibNamed:[[OrganizationAboutView class] description] owner:self options:nil] lastObject];
    }
    
    return _aboutView;
}

@end
