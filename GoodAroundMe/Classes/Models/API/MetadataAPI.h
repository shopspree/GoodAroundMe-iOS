//
//  MetadataAPI.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "BaseAPI.h"

@interface MetadataAPI : BaseAPI

+ (void)metadata:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure;

@end
