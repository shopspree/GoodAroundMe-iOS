//
//  Newsfeed+Activity.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Newsfeed+Activity.h"
#import "ApplicationHelper.h"
#import "User+Create.h"
#import "Post+Create.h"
#import "Comment+Create.h"
#import "Like+Create.h"
#import "FeedAPI.h"


@implementation Newsfeed (Activity)

+ (void)synchronizeInContext:(NSManagedObjectContext *)context success:(void (^)())success
failure:(void (^)(NSString *message))failure
{
    [FeedAPI newsfeeds:^(NSDictionary *responseDictionary) {
        NSArray *newsfeedArray = responseDictionary[@"activities"];
        for (NSDictionary *newsfeedDictionary in newsfeedArray) {
            [Newsfeed newsfeedWithActivity:newsfeedDictionary[ACTIVITY] inManagedObjectContext:context];
        }
        success();
    }
    failure:^(NSString *message) {
        failure(message);
    }];
}


+ (Newsfeed *)newsfeedWithActivity:(NSDictionary *)activityDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Newsfeed *newsfeed = nil;
    
    // Build a fetch request to see if we can find this Flickr photo in the database.
    // The "unique" attribute in Photo is Flickr's "id" which is guaranteed by Flickr to be unique.
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Newsfeed"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [activityDictionary[ACTIVITY_ID] description]];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    
    if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
        NSLog(@"[DEBUG] <Newsfeed+Activity> Newsfeed object not found for id = %@!!", [activityDictionary[ACTIVITY_ID] description]);

        // handle error
    } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
        newsfeed = [NSEntityDescription insertNewObjectForEntityForName:@"Newsfeed" inManagedObjectContext:context];
        [newsfeed setWithDictionary:activityDictionary];
                
    } else {
        newsfeed = [matches lastObject];
        [newsfeed updateWithDictionary:activityDictionary];
    }
    
    return newsfeed;
}

- (void)setWithDictionary:(NSDictionary *)activityDictionary
{
    
    self.uid = [activityDictionary[ACTIVITY_ID] description];
    self.type = [activityDictionary[ACTIVITY_TYPE] description];
    self.created_at = [ApplicationHelper dateFromString:[activityDictionary[ACTIVITY_CREATED_AT] description]];
    self.updated_at = [ApplicationHelper dateFromString:[activityDictionary[ACTIVITY_UPDATED_AT] description]];
    
    Post *post = [Post postWithDictionary:activityDictionary[ACTIVITY_POST] inManagedObjectContext:self.managedObjectContext];
    self.post = post;
    self.organization = post.organization;
    
    if (activityDictionary[ACTIVITY_COMMENT]) {
        Comment *comment = [Comment commentWithDictionary:activityDictionary[ACTIVITY_COMMENT] inManagedObjectContext:self.managedObjectContext];
        self.comment = comment;
        self.comment.post = self.post;
    } else if (activityDictionary[ACTIVITY_LIKE]) {
        Like *like = [Like likeWithDictionary:activityDictionary[ACTIVITY_LIKE] inManagedObjectContext:self.managedObjectContext];
        self.like = like;
        self.like.post = self.post;
    }

}

- (void)updateWithDictionary:(NSDictionary *)activityDictionary
{
    [self.post setWithDictionary:activityDictionary[ACTIVITY_POST]];
}

- (NSString *)description
{
    NSString *desc = [NSString stringWithFormat:@"\n[Newsfeed] uid=%@, type=%@, created_at=%@, updated_at=%@, post=%@, comment=%@, likes=%@",
                      [self.uid description],
                      [self.type description],
                      [self.created_at description],
                      [self.updated_at description],
                      [self.post description],
                      [self.comment description],
                      [self.like description]];
    
    return desc;
}

@end
