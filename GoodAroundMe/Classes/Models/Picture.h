//
//  Picture.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/15/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Post *post;

@end
