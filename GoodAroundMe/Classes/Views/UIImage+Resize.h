//
//  UIImage+Resize.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/31/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)scaleToSize:(CGSize)newSize;
- (UIImage*)imageScaledToWidth:(CGFloat)targetWidth;
- (UIImage *)imageScaledToSize:(CGSize)targetSize;
- (NSData *)imageData;
- (NSInteger)imageSizeBytes;
@end
