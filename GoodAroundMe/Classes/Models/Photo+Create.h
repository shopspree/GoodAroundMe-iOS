//
//  Photo+Create.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Photo.h"

#define PHOTO @"photo"
#define PHOTO_ID @"id"
#define PHOTO_URL @"url"
#define PHOTO_CREATED_AT @"created_at"
#define PHOTO_UPDATED_AT @"updated_at"

@interface Photo (Create)

+ (Photo *)photoWithDictionary:(NSDictionary *)photoDictionary post:(Post *)post;

- (void)setWithDictionary:(NSDictionary *)photoDictionary;

@end
