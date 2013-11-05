//
//  ApplicationDictionary.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/28/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "ApplicationDictionary.h"
#import "MetadataAPI.h"

@implementation ApplicationDictionary

static ApplicationDictionary *sharedObject = nil;

+ (ApplicationDictionary *)sharedInstance
{
    static dispatch_once_t _singletonPredicate;
    
    dispatch_once(&_singletonPredicate, ^{
        sharedObject = [[super allocWithZone:nil] init];
    });
    
    return sharedObject;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (void)loadDictionary:(void (^)())success failure:(void (^)(NSString *message))failure
{
    self.dictionary = [NSDictionary dictionary];
    [MetadataAPI metadata:^(NSDictionary *responseDictionary) {
        if (responseDictionary) {
            for (NSString *key in [self keys]) {
                NSLog(@"[DEBUG] <ApplicationDictionary> Set value %@ for %@", responseDictionary[DictionaryMetadata][key], key);
                [self setObject:responseDictionary[DictionaryMetadata][key] forKey:key];
            }
        }
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key
{
    NSMutableDictionary *dictionaryCopy = [self.dictionary mutableCopy];
    [dictionaryCopy setObject:object forKey:key];
    self.dictionary = dictionaryCopy;
}

- (NSArray *)keys
{
    NSArray *keys = @[DictionaryAmazonS3AppID, DictionaryAmazonS3AppSecret, DictionaryGiveEnabled, DictionaryGiveURL, DictionaryAboutURL, DictionaryImageSizeThreshold];
    return keys;
}
 

@end
