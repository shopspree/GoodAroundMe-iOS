//
//  Post.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Comment, Hashtag, Like, Newsfeed, Picture, Subcategory, User, Video;

@interface Post : NSManagedObject

@property (nonatomic, retain) NSNumber * comments_count;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * liked_by_user;
@property (nonatomic, retain) NSNumber * likes_count;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSSet *hashtags;
@property (nonatomic, retain) NSSet *likes;
@property (nonatomic, retain) Newsfeed *newsfeed;
@property (nonatomic, retain) NSSet *pictures;
@property (nonatomic, retain) Subcategory *subcategories;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *videos;
@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

- (void)addHashtagsObject:(Hashtag *)value;
- (void)removeHashtagsObject:(Hashtag *)value;
- (void)addHashtags:(NSSet *)values;
- (void)removeHashtags:(NSSet *)values;

- (void)addLikesObject:(Like *)value;
- (void)removeLikesObject:(Like *)value;
- (void)addLikes:(NSSet *)values;
- (void)removeLikes:(NSSet *)values;

- (void)addPicturesObject:(Picture *)value;
- (void)removePicturesObject:(Picture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

- (void)addVideosObject:(Video *)value;
- (void)removeVideosObject:(Video *)value;
- (void)addVideos:(NSSet *)values;
- (void)removeVideos:(NSSet *)values;

@end
