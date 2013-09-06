//
//  Post.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/31/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Like, Newsfeed, Organization, Picture, User;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * liked_by_user;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) User *contributor;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) Newsfeed *newsfeed;
@property (nonatomic, retain) Organization *organization;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
