//
//  MenuItemCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/13/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "MenuItemCell.h"

@implementation MenuItemCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGPoint startOfLine = CGPointMake(20, 57);
    CGPoint endOfLine =  CGPointMake(130, 57);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startOfLine];
    [path addLineToPoint:endOfLine];
    [path stroke];
}



@end
