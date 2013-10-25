//
//  UIImage+Resize.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/31/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UIImage+Resize.h"

static CGFloat MaxImageSizeKB = 50.0f;

@implementation UIImage (Resize)

- (UIImage *)scaleToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(UIImage*)imageScaledToWidth:(CGFloat)targetWidth
{
    float oldWidth = self.size.width;
    float scaleFactor = targetWidth / oldWidth;
    
    float newHeight = self.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageScaledToSize:(CGSize)targetSize
{
    NSInteger imageSizeBytes = [self imageSizeBytes];
    CGFloat scaleFactor = imageSizeBytes > MaxImageSizeKB*1024.0f ? (MaxImageSizeKB*1024.0f/imageSizeBytes) : 1;
    UIImage *scaledImage = [UIImage imageWithCGImage:[self CGImage]
                                               scale:scaleFactor
                                         orientation:self.imageOrientation];
    NSLog(@"[DEBUG] <UIIMage+Resize> Scaled image to size: \nScale factor:%f \nOriginal: %d \nScaled size:%d", scaleFactor, imageSizeBytes, [scaledImage imageSizeBytes]);
    return scaledImage;
}

- (UIImage *)resizeImageToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}

- (NSData *)imageData
{
    NSData *imageData = UIImagePNGRepresentation(self);
    return imageData;
}

- (NSInteger)imageSizeBytes
{
    NSData *imageData = [self imageData];
    NSInteger imageSizeBytes = imageData.length;
    return imageSizeBytes;
}

@end
