//
//  Like+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Like+Create.h"
#import "ApplicationHelper.h"

@implementation Like (Create)

+ (Like *)likeWithDictionary:(NSDictionary *)likeDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [Like likeWithDictionary:likeDictionary forUser:nil inManagedObjectContext:context];
}

+ (Like *)likeWithDictionary:(NSDictionary *)likeDictionary forUser:(User *)user inManagedObjectContext:(NSManagedObjectContext *)context
{
    Like *like = nil;
    
    if (likeDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Like"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [likeDictionary[LIKE_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            like = [NSEntityDescription insertNewObjectForEntityForName:@"Like" inManagedObjectContext:context];
            [like setWithDictionary:likeDictionary];
            
            //User *user = [User userWithDictionary:likeDictionary[LIKE_USER] inManagedObjectContext:context];
            //like.user = user;
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            like = [matches lastObject];
            [like setWithDictionary:likeDictionary];
        }
        
    }
    
    return like;
}

+ (BOOL)post:(Post *)post likedByUser:(User *)user
{
    BOOL isLiked = NO;
    
    if ([Like user:user likeOnPost:post]) isLiked = YES;
    
    return isLiked;
}

+ (Like *)user:(User *)user likeOnPost:(Post *)post
{
    Like *like = nil;
    
    if (post && user) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Like"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"post = %@ AND user = %@", post, user];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [post.managedObjectContext executeFetchRequest:request error:&error];
        NSLog(@"[DEBUG] <Like+Create> %d likes on post (%@) %@ and is liked by user %@", [post.likes count], post.uid, post.title, post.liked_by_user);
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            // do nothing
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            like = [matches lastObject];
        }
        
    }
    
    return like;
}

- (void)setWithDictionary:(NSDictionary *)likeDictionary
{
    NSDate *serverUpdateDate = [ApplicationHelper dateFromString:[likeDictionary[LIKE_UPDATED_AT] description]];
    if (YES || ! [self.updated_at compare:serverUpdateDate]) {
        self.uid = [likeDictionary[LIKE_ID] description];
        self.created_at = [ApplicationHelper dateFromString:[likeDictionary[LIKE_CREATED_AT] description]];
        self.updated_at = [ApplicationHelper dateFromString:[likeDictionary[LIKE_UPDATED_AT] description]];
    }
    
    User *user = [User userWithDictionary:likeDictionary[LIKE_USER] inManagedObjectContext:self.managedObjectContext];
    self.user = user;
}

- (NSString *)description2
{
    NSString *desc = [NSString stringWithFormat:@"\n\n[Like] uid=%@, created_at=%@, updated_at=%@, post=%@\n",
                      [self.uid description],
                      [self.created_at description],
                      [self.updated_at description],
                      [self.post description]];
    
    return desc;
}


@end
