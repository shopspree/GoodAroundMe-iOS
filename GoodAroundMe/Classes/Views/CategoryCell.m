//
//  CategoryCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)setCategoryLabel:(UILabel *)categoryLabel
{
    _categoryLabel = categoryLabel;
    
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.alpha = 0.75;
    
    self.categoryLabel.textColor = [UIColor blackColor];
    self.categoryLabel.numberOfLines = 0;
    [self.categoryLabel setLineBreakMode:NSLineBreakByWordWrapping]; //will wrap text in new line
    [self.categoryLabel sizeToFit];
    [self.categoryLabel setLineBreakMode:NSLineBreakByWordWrapping];
}

@end
