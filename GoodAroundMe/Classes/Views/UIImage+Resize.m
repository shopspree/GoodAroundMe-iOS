//
//  UIImage+Resize.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/31/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)scaleToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
