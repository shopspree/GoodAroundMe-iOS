//
//  CategoryAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"
#import "Category.h"

@interface CategoryAPI : BaseAPI

+ (void)categories:(void (^)(NSDictionary *reponseDictionary))success
           failure:(void (^)(NSDictionary *errorData))failure;

@end
