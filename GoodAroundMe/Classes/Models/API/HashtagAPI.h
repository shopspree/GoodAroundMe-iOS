//
//  HashtagAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/11/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseAPI.h"

@interface HashtagAPI : BaseAPI

+ (void)hashtags:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;

@end
