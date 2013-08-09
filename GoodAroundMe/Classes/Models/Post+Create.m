//
//  Post+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Post+Create.h"
#import "User+Create.h"
#import "Picture+Create.h"
#import "Like+Create.h"
#import "Comment+Create.h"
#import "Newsfeed+Activity.h"
#import "Hashtag+Create.h"
#import "ApplicationHelper.h"
#import "PostAPI.h"
#import "FeedAPI.h"

@implementation Post (Create)

#pragma mark - post

+ (void)findPost:(NSString *)postID managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSDictionary *errorData))failure
{
    if (postID) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", postID];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            failure(nil);
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            [PostAPI post:postID success:^(NSDictionary *responseDictionary) {
                Post *post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:managedObjectContext];
                [post setWithDictionary:responseDictionary];
                success(post);
            } failure:^(NSDictionary *errorData) {
                failure(errorData);
            }];
            
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            Post *post = [matches lastObject];
            success(post);
        }
        
    };
    
}

+ (void)popular:(NSManagedObjectContext *)managedObjectContext success:(void (^)(NSArray *postArray))success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI popular:^(NSDictionary *responseDictionary) {
        NSMutableArray *postArray = [NSMutableArray array];
        for (NSDictionary *postDictionary in responseDictionary[@"posts"]) {
            Post *post = [Post postWithDictionary:postDictionary[POST] inManagedObjectContext:managedObjectContext];
            [postArray addObject:post];
            NSLog(@"post %@ pictures count = %d", post.uid, [post.pictures count]);
        }
        for (Post *post in postArray) {
            NSLog(@"post %@ pictures count = %d", post.uid, [post.pictures count]);
        }
        
        success(postArray);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
    
}

+ (void)newPost:(NSDictionary *)postDictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI newPost:postDictionary success:^(NSDictionary *responseDictionary) {
        Post *post = [Post postWithDictionary:postDictionary inManagedObjectContext:managedObjectContext];
        if (success) {
            success(post);
        }
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (Post *)postWithDictionary:(NSDictionary *)postDictionary  inManagedObjectContext:(NSManagedObjectContext *)context
{
    Post *post = nil;
    
    if (postDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [postDictionary[POST_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
            [post setWithDictionary:postDictionary];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            post = [matches lastObject];
            [post setWithDictionary:postDictionary];
        }
        
    }
    return post;
    
}

- (void)setWithDictionary:(NSDictionary *)postDictionary
{
    
    self.uid = [postDictionary[POST_ID] description];
    self.title = [postDictionary[POST_TITLE] description];
    self.content = [postDictionary[POST_CONTENT] description];
    self.created_at = [ApplicationHelper dateFromString:[postDictionary[POST_CREATED_AT] description]];
    self.updated_at = [ApplicationHelper dateFromString:[postDictionary[POST_UPDATED_AT] description]];
    self.comments_count = [ApplicationHelper numberFromString:[postDictionary[POST_COMMENTS_COUNT] description]];
    self.likes_count = [ApplicationHelper numberFromString:[postDictionary[POST_LIKES_COUNT] description]];
    self.liked_by_user = @([[postDictionary[POST_LIKED_BY_USER] description] intValue]);
    
    User *user = [User userWithDictionary:postDictionary[POST_USER] inManagedObjectContext:self.managedObjectContext];
    self.user = user;

    for (NSDictionary *mediaDictionary in postDictionary[POST_MEDIAS]) {
        NSLog(@"Post (%@) MediaType = %@", self.uid, mediaDictionary[MEDIA_TYPE]);
        if ([mediaDictionary[MEDIA_TYPE] isEqualToString:MEDIA_TYPE_PICTURE]) {
            Picture *picture = [Picture pictureWithDictionary:mediaDictionary post:self];
            [self addPicturesObject:picture];
            
        } 
    }
    
    for (NSDictionary *hashtagDictionary in postDictionary[POST_HASHTAGS]) {
        Hashtag *hashtag = [Hashtag hashtagWithDictionary:hashtagDictionary[HASHTAG] inManagedObjectContext:self.managedObjectContext];
        [hashtag addPostsObject:self];
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"save for post %@ failed", self.uid);
    }
}

- (void)deletePost:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI deletePost:self success:^{
        if (self.newsfeed)  {
            [self.managedObjectContext deleteObject:self.newsfeed];
        }
        
        [self.managedObjectContext deleteObject:self];
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

#pragma mark - like

- (void)likes:(void (^)(NSArray *likes))success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI likesOnPost:self success:^(NSDictionary *responseDictionary) {
        if (responseDictionary) {
            if (responseDictionary[POST]) {
                [self setWithDictionary:responseDictionary[POST]];
            }
            
            NSMutableArray *likes = [NSMutableArray array];
            for (NSDictionary *likeDictionary in responseDictionary[@"likes"]) {
                Like *like = [Like likeWithDictionary:likeDictionary[LIKE] inManagedObjectContext:self.managedObjectContext];
                like.post = self;
                [likes addObject:like];
            }
            
            success(likes);
        }
        
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

- (void)like:(void (^)(Like *like))success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI likePost:self success:^(NSDictionary *responseDictionary) {
        NSDictionary *postDictionary = [responseDictionary objectForKey:POST];
        [self setWithDictionary:postDictionary];
        
        NSDictionary *likeDictionary = [responseDictionary objectForKey:LIKE];
        Like *like = [Like likeWithDictionary:likeDictionary inManagedObjectContext:self.managedObjectContext];
        success(like);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

- (void)unlike:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    // TO DO: get current user
    Like *like = [Like user:[User curretnUser:self.managedObjectContext] likeOnPost:self];
    [PostAPI unlike:like post:self success:^(NSDictionary *responseDictionary) {
        [self.managedObjectContext deleteObject:like];
        
        NSError *error = nil;
        [self.managedObjectContext save:&error];
        
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        
        success();
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }]; 
}

#pragma mark - comment

- (void)comments:(void (^)(NSArray *comments))success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI commentsOnPost:self success:^(NSDictionary *responseDictionary) {
        if (responseDictionary) {
            
            [self setWithDictionary:responseDictionary[POST]];
            
            NSMutableArray *comments = [NSMutableArray array];
            for (NSDictionary *commentDictionary in responseDictionary[@"comments"]) {
                Comment *comment = [Comment commentWithDictionary:commentDictionary[COMMENT] inManagedObjectContext:self.managedObjectContext];
                comment.post = self;
                [comments addObject:comment];
            }
            success(comments);
        }
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

- (void)comment:(NSString *)content success:(void (^)(Comment *comment))success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI comment:content onPost:self success:^(NSDictionary *responseDictionary) {
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        
        NSDictionary *commentDictionary = responseDictionary[COMMENT];
        Comment *comment = [Comment commentWithDictionary:commentDictionary inManagedObjectContext:self.managedObjectContext];
        comment.post = self;
        success(comment);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

- (void)deleteComment:(Comment *)comment
              success:(void (^)())success
              failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI deleteComment:comment onPost:self success:^(NSDictionary *responseDictionary) {
        if (comment) {
            if (comment.newsfeed)  {
                [self.managedObjectContext deleteObject:comment.newsfeed];
            }
            
            [self.managedObjectContext deleteObject:comment];
        }
        
        //NSError *error = nil;
        //[self.managedObjectContext save:&error];
        
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        success();
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

#pragma mark - inappropriate report

- (void)inappropriate:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [PostAPI inappropriatePost:self success:^{
        if (success) {
            success();
        }
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

#pragma mark - activity

- (void)newsfeedForPost:(void (^)(Newsfeed *newsfeed))success failure:(void (^)(NSDictionary *errorData))failure
{
    [FeedAPI postNewsfeed:self.uid success:^(NSDictionary *responseDictionary) {
        NSDictionary *newsfeedDictionary = [responseDictionary[@"activities"] lastObject];
        Newsfeed *newsfeed = [Newsfeed newsfeedWithActivity:newsfeedDictionary[ACTIVITY] inManagedObjectContext:self.managedObjectContext];
        success(newsfeed);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

#pragma mark - misc

- (NSString *)description2
{
    NSString *desc = [NSString stringWithFormat:@"\n[Post] uid=%@, title=%@, content=%@, created_at=%@, updated_at=%@, comments_count=%@, likes_count=%@, pictures=, videos= \n",
     [self.uid description],
     [self.title description],
     [self.content description],
     [self.created_at description],
     [self.updated_at description],
     [self.comments_count description],
     [self.likes_count description]];

    return desc;
}

- (NSData *)toJSON
{
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.uid, POST_ID,
                              nil];
    NSData *jsonData = [ApplicationHelper constructJSON:jsonDict];
    return jsonData;
}

@end
