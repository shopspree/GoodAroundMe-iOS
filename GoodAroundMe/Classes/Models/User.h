//
//  User.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Company, Group, Like, Newsfeed, Notification, Post;

@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * full_name;
@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) Company *company;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) NSSet *newsfeeds;
@property (nonatomic, retain) NSSet *notifications;
@property (nonatomic, retain) NSSet *posts;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addNewsfeedsObject:(Newsfeed *)value;
- (void)removeNewsfeedsObject:(Newsfeed *)value;
- (void)addNewsfeeds:(NSSet *)values;
- (void)removeNewsfeeds:(NSSet *)values;

- (void)addNotificationsObject:(Notification *)value;
- (void)removeNotificationsObject:(Notification *)value;
- (void)addNotifications:(NSSet *)values;
- (void)removeNotifications:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
