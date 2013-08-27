//
//  Like.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Newsfeed, Post, User;

@interface Like : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Newsfeed *newsfeed;
@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) User *user;

@end
