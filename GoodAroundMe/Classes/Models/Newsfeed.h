//
//  Newsfeed.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/15/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Like, Post;

@interface Newsfeed : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) Comment *comment;
@property (nonatomic, retain) Like *like;
@property (nonatomic, retain) Post *post;

@end
