//
//  Media.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/22/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Media : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * image_url;
@property (nonatomic, retain) Post *post;

@end
