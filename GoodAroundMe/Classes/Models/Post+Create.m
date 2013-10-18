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
#import "Organization+Create.h"
#import "Newsfeed+Activity.h"
#import "ApplicationHelper.h"
#import "PostAPI.h"
#import "FeedAPI.h"
#import "AppConstants.h"

@implementation Post (Create)

#pragma mark - post

+ (void)findPost:(NSString *)postID managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSString *message))failure
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
            } failure:^(NSString *message) {
                failure(message);
            }];
            
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            Post *post = [matches lastObject];
            success(post);
        }
        
    };
    
}

+ (void)newPost:(NSDictionary *)postDictionary managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(Post *post))success failure:(void (^)(NSString *message))failure
{
    [PostAPI newPost:postDictionary success:^(NSDictionary *responseDictionary) {
        Post *post = [Post postWithDictionary:postDictionary inManagedObjectContext:managedObjectContext];
        if (success) {
            success(post);
        }
    } failure:^(NSString *message) {
        failure(message);
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
    [self setUid:[postDictionary[POST_ID] description]];
    [self setTitle:[postDictionary[POST_TITLE] description]];
    [self setCaption:[postDictionary[POST_CAPTION] description]];
    [self setCreated_at:[ApplicationHelper dateFromString:[postDictionary[POST_CREATED_AT] description]]];
    [self setUpdated_at:[ApplicationHelper dateFromString:[postDictionary[POST_UPDATED_AT] description]]];
    [self setComments_count:[ApplicationHelper numberFromString:[postDictionary[POST_COMMENTS_COUNT] description]]];
    [self setLikes_count:[ApplicationHelper numberFromString:[postDictionary[POST_LIKES_COUNT] description]]];
    [self setContributor:[postDictionary[POST_CONTRIBUTOR] description]];
    
    if (postDictionary[LIKE]) {
        NSDictionary *likeDictionary = postDictionary[LIKE];
        Like *like = [Like likeWithDictionary:likeDictionary inManagedObjectContext:self.managedObjectContext];
        [self addLikesObject:like];
        [self setLiked_by_user:[NSNumber numberWithBool:YES]];
    } else {
        [self setLiked_by_user:[NSNumber numberWithBool:NO]];
    }
    
    if (postDictionary[POST_USER]) {
        NSDictionary *userDictionary = postDictionary[POST_USER];
        User *user = [User userWithDictionary:userDictionary inManagedObjectContext:self.managedObjectContext];
        [self setUser:user];
    }
    
    if (postDictionary[POST_ORGANIZATION]) {
        Organization *organization = [Organization organizationWithDictionary:postDictionary[POST_ORGANIZATION] inManagedObjectContext:self.managedObjectContext];
        [self setOrganization:organization];
    }

    for (NSDictionary *mediaDictionary in postDictionary[POST_MEDIAS]) {
        if ([mediaDictionary[MEDIA_TYPE] isEqualToString:MEDIA_TYPE_PICTURE]) {
            Picture *picture = [Picture pictureWithDictionary:mediaDictionary post:self];
            [self addPicturesObject:picture];
        } 
    }
}

- (void)deletePost:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [PostAPI deletePost:self success:^{
        if (self.newsfeed)  {
            [self.managedObjectContext deleteObject:self.newsfeed];
        }
        
        [self.managedObjectContext deleteObject:self];
    } failure:^(NSString *message) {
        failure(message);
    }];
}

#pragma mark - like

- (void)likes:(void (^)(NSArray *likes))success failure:(void (^)(NSString *message))failure
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
        
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)like:(void (^)(Like *like))success failure:(void (^)(NSString *message))failure
{
    NSLog(@"[DEBUG] <Post + Create> Pre Like on post %@ likes count is %@", self.uid, self.likes_count);
    
    self.liked_by_user = [NSNumber numberWithBool:YES];
    NSInteger updatedLikesCount = [self.likes_count integerValue] + 1;
    self.likes_count = [NSNumber numberWithInteger:updatedLikesCount];
    
    NSLog(@"[DEBUG] <Post + Create> Post Like on post %@ likes count is %@", self.uid, self.likes_count);
    
    [PostAPI likePost:self success:^(NSDictionary *responseDictionary) {
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        success(nil);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)unlike:(void (^)())success failure:(void (^)(NSString *message))failure
{
    Like *like = [Like user:[User currentUser:self.managedObjectContext] likeOnPost:self];
    if (!like) {
        return;
    }
    [self removeLikesObject:like];
    
    NSLog(@"[DEBUG] <Post + Create> Pre-Unlike on post %@ likes count is %@", self.uid, self.likes_count);
    
    self.liked_by_user = [NSNumber numberWithBool:NO];
    NSInteger updatedLikesCount = [self.likes_count integerValue] - 1;
    self.likes_count = [NSNumber numberWithInteger:updatedLikesCount];
    
    NSLog(@"[DEBUG] <Post + Create> Post-Unlike on post %@ likes count is %@", self.uid, self.likes_count);
    
    [PostAPI unlike:like post:self success:^(NSDictionary *responseDictionary) {
        [self.managedObjectContext deleteObject:like];
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

#pragma mark - comment

- (void)comments:(void (^)(NSArray *comments))success failure:(void (^)(NSString *message))failure
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
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)comment:(NSString *)content success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.managedObjectContext];
    comment.content = content;
    comment.user = [User currentUser:self.managedObjectContext];
    comment.created_at = [NSDate date];
    comment.updated_at = [NSDate date];
    comment.post = self;
    NSLog(@"[DEBUG] <CommentCell> Comment user is %@ %@ %@", comment.user.firstname, comment.user.lastname, comment.user.thumbnailURL);
    [PostAPI comment:comment onPost:self success:^(NSDictionary *responseDictionary, Comment *comment) {
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        
        NSDictionary *commentDictionary = responseDictionary[COMMENT];
        [comment setWithDictionary:commentDictionary];
        comment.post = self;
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)deleteComment:(Comment *)comment
              success:(void (^)())success
              failure:(void (^)(NSString *message))failure
{
    [PostAPI deleteComment:comment onPost:self success:^(NSDictionary *responseDictionary) {
        if (comment) {
            if (comment.newsfeed)  {
                [self.managedObjectContext deleteObject:comment.newsfeed];
            }
            [self.managedObjectContext deleteObject:comment];
        }
        
        NSDictionary *postDictionary = responseDictionary[POST];
        [self setWithDictionary:postDictionary];
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

#pragma mark - inappropriate report

- (void)inappropriate:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [PostAPI inappropriatePost:self success:^{
        if (success) {
            success();
        }
    } failure:^(NSString *message) {
        failure(message);
    }];
}

#pragma mark - activity

- (void)newsfeedForPost:(void (^)(Newsfeed *newsfeed))success failure:(void (^)(NSString *message))failure
{
    [FeedAPI postNewsfeed:self.uid success:^(NSDictionary *responseDictionary) {
        NSDictionary *newsfeedDictionary = [responseDictionary[@"activities"] lastObject];
        Newsfeed *newsfeed = [Newsfeed newsfeedWithActivity:newsfeedDictionary[ACTIVITY] inManagedObjectContext:self.managedObjectContext];
        success(newsfeed);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

#pragma mark - misc

- (NSData *)toJSON
{
    NSDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.uid, POST_ID,
                              nil];
    NSData *jsonData = [ApplicationHelper constructJSON:jsonDict];
    return jsonData;
}

@end
