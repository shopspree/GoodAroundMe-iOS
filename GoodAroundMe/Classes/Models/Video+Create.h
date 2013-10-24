//
//  Photo+Create.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Video.h"

#define VIDEO @"video"
#define VIDEO_ID @"id"
#define VIDEO_URL @"url"
#define VIDEO_IMAGE_URL @"image_url"
#define VIDEO_CREATED_AT @"created_at"
#define VIDEO_UPDATED_AT @"updated_at"

@interface Video (Create)

+ (Video *)videoWithDictionary:(NSDictionary *)videoDictionary post:(Post *)post;

- (void)setWithDictionary:(NSDictionary *)videoDictionary;

@end
