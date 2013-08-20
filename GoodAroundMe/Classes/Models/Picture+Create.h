//
//  Picture+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Picture.h"

#define PICTURE_ID @"id"
#define PICTURE_URL @"url"
#define PICTURE_CREATED_AT @"created_at"
#define PICTURE_UPDATED_AT @"updated_at"

@interface Picture (Create)

+ (Picture *)pictureWithDictionary:(NSDictionary *)pictureDictionary post:(Post *)post;

- (void)setWithDictionary:(NSDictionary *)pictureDictionary;

@end
