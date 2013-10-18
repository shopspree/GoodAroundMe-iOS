//
//  AmazonAPI.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/23/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <AWSS3/AWSS3.h>
#import <Foundation/Foundation.h>

#define MY_SECRET_KEY @"Hg1vYx8K/+IcntjgTScefb4ox7TxRETuuQ+YKkF7"
#define MY_ACCESS_KEY_ID @"AKIAIYFCVLE2OKFN4FUQ"
#define MY_PICTURE_BUCKET @"GoodAroundMe/media"

@interface AmazonAPI : NSObject

- (void)uploadImage:(UIImage *)image toBucket:(NSString *)bucketName delegate:(id<AmazonServiceRequestDelegate>)delegate;

@end
