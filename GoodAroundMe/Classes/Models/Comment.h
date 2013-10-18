//
//  Comment.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/31/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Newsfeed, Post, User;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * liked_by_user;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Newsfeed *newsfeed;
@property (nonatomic, retain) Post *post;
@property (nonatomic, retain) User *user;

@end
