//
//  Organization.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Organization : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * posts_count;
@property (nonatomic, retain) NSNumber * followers_count;
@property (nonatomic, retain) NSString * image_thumbnail_url;
@property (nonatomic, retain) NSString * web_site_url;
@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSNumber * is_followed;
@property (nonatomic, retain) Category *category;

@end
