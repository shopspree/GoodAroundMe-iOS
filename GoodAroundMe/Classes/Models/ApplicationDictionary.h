//
//  ApplicationDictionary.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/28/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DictionaryMetadata @"metadata"
#define DictionaryAmazonS3AppID @"amazon_s3_app_id"
#define DictionaryAmazonS3AppSecret @"amazon_s3_app_secret"
#define DictionaryGiveEnabled @"give_enabled"
#define DictionaryGiveURL @"give_url"
#define DictionaryAboutURL @"about_url"
#define DictionaryImageSizeThreshold @"image_size_bytes_threshold"

@interface ApplicationDictionary : NSObject

@property (strong, nonatomic) NSDictionary *dictionary;

+ (ApplicationDictionary *)sharedInstance;
- (void)loadDictionary:(void (^)())success failure:(void (^)(NSString *message))failure;

@end
