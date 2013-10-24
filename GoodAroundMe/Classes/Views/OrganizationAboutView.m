//
//  OrganizationAboutView.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/24/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "OrganizationAboutView.h"

@implementation OrganizationAboutView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGFloat)sizeToFitText:(NSString *)text
{
    CGFloat height = self.frame.size.height;
    
    CGSize adjustedSize = [text sizeWithFont:self.aboutTextView.font
                           constrainedToSize:CGSizeMake(self.aboutTextView.frame.size.width, 1000)];
    
    CGFloat adjustedHeight = adjustedSize.height;
    CGFloat delta = (adjustedHeight - height);
    
    height += delta;
    
    return height;
}

@end
