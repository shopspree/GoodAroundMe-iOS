//
//  Organization.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/22/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Newsfeed, OrganizationCategory, Post, User;

@interface Organization : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSNumber * followers_count;
@property (nonatomic, retain) NSString * image_thumbnail_url;
@property (nonatomic, retain) NSNumber * is_followed;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * posts_count;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * web_site_url;
@property (nonatomic, retain) NSSet *admins;
@property (nonatomic, retain) OrganizationCategory *category;
@property (nonatomic, retain) NSSet *followers;
@property (nonatomic, retain) NSSet *newsfeeds;
@property (nonatomic, retain) NSSet *posts;
@end

@interface Organization (CoreDataGeneratedAccessors)

- (void)addAdminsObject:(User *)value;
- (void)removeAdminsObject:(User *)value;
- (void)addAdmins:(NSSet *)values;
- (void)removeAdmins:(NSSet *)values;

- (void)addFollowersObject:(User *)value;
- (void)removeFollowersObject:(User *)value;
- (void)addFollowers:(NSSet *)values;
- (void)removeFollowers:(NSSet *)values;

- (void)addNewsfeedsObject:(Newsfeed *)value;
- (void)removeNewsfeedsObject:(Newsfeed *)value;
- (void)addNewsfeeds:(NSSet *)values;
- (void)removeNewsfeeds:(NSSet *)values;

- (void)addPostsObject:(Post *)value;
- (void)removePostsObject:(Post *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

@end
