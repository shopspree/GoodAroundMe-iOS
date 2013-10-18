//
//  GAMCache.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/28/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "GAMCache.h"

@interface GAMCache ()

@property (strong, nonatomic) NSDictionary *cacheDictionary;

@end

@implementation GAMCache

static GAMCache *instance = nil;

+ (GAMCache *)getInstance
{
    if(!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{                 // all threads will block here until the block executes
            instance = [[GAMCache alloc] init]; // this line of code can only ever happen once
        });
    }
    return instance;
}

- (NSDictionary *)cacheDictionary
{
    if (!_cacheDictionary) {
        _cacheDictionary = [NSDictionary dictionary];
    }
    return _cacheDictionary;
}

@end
