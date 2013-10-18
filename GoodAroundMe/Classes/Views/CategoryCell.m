//
//  CategoryCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
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
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.alpha = 0.75;
    
    self.layer.borderWidth = 5.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //self.categoryLabel.textColor = [UIColor blackColor];
    //self.categoryLabel.numberOfLines = 0;
    //[self.categoryLabel setLineBreakMode:NSLineBreakByWordWrapping]; //will wrap text in new line
    //self.categoryLabel.adjustsFontSizeToFitWidth = YES;
    //self.categoryLabel.minimumScaleFactor = 0.5;
    //self.categoryLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //self.categoryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //self.categoryLabel.numberOfLines = 0;
    //[self.categoryLabel sizeToFit];
}

@end
