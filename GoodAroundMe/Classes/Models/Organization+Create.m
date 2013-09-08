//
//  Organization+Create.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "Organization+Create.h"
#import "OrganizationAPI.h"
#import "ApplicationHelper.h"
#import "Newsfeed+Activity.h"
#import "Post+Create.h"
#import "User+Create.h"
#import "OrganizationCategory+Create.h"

@implementation Organization (Create)

+ (Organization *)organizationWithDictionary:(NSDictionary *)organizationDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Organization *organization = nil;
    
    if (organizationDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Organization"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [organizationDictionary[ORGANIZATION_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            organization = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:context];
            [organization setWithDictionary:organizationDictionary];
        } else { // found it, just return it from the list of matches (which there will only be one of)
            organization = [matches lastObject];
            [organization setWithDictionary:organizationDictionary];
        }
        
    }
    
    return organization;
}

- (void)create:(void (^)())success failure:(void (^)(NSString *message))failure
{
    if (!self.name || self.name.length ==0) {
        failure(@"Name value is missing");
        return;
    }
    else if (!self.category) {
        failure(@"Invalid category");
        return;
    }
    
    [OrganizationAPI newOrganization:self success:^(NSDictionary *responseDictionary) {
        NSDictionary *organizationDictionary = responseDictionary[ORGANIZATION];
        [self setWithDictionary:organizationDictionary];
        
        if (responseDictionary[USER]) {
            User *user = [User currentUser:self.managedObjectContext];
            [user setWithDictionary:responseDictionary[USER]];
            success();
        }
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)update:(void (^)())success failure:(void (^)(NSString *message))failure
{
    if (!self.name || self.name.length ==0) {
        failure(@"Name value is missing");
        return;
    }
    else if (!self.category) {
        failure(@"Invalid category");
        return;
    }
    
    [OrganizationAPI updateOrganization:self success:^(NSDictionary *reponseDictionary) {
        NSDictionary *organizationDictionary = reponseDictionary[ORGANIZATION];
        [self setWithDictionary:organizationDictionary];
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}


- (void)newsfeedForOrganization:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [OrganizationAPI newsfeedForOrganization:self success:^(NSDictionary *reponseDictionary) {
        NSArray *activities = reponseDictionary[@"activities"];
        
        for (NSDictionary *activityDictionary in activities) {
            Newsfeed *newsfeed = [Newsfeed newsfeedWithActivity:activityDictionary[ACTIVITY] inManagedObjectContext:self.managedObjectContext];
            [self addPostsObject:newsfeed.post];
        }
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (NSArray *)postsForOrganization:(void (^)(NSArray *posts))success failure:(void (^)(NSString *message))failure
{
    NSMutableArray *posts = [[self fetchOrganizationPosts] mutableCopy];
    
    [OrganizationAPI postsForOrganization:self success:^(NSDictionary *reponseDictionary) {
        NSMutableArray *posts = [reponseDictionary[@"posts"] mutableCopy];
        
        for (NSDictionary *postDictionary in posts) {
            Post *post = [Post postWithDictionary:postDictionary inManagedObjectContext:self.managedObjectContext];
            post.organization = self;
        }
        
        posts = [[self fetchOrganizationPosts] mutableCopy];
        success(posts);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
    return posts;
}

- (NSArray *)fetchOrganizationPosts
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"organization = %@", self];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    NSMutableArray *posts = [matches mutableCopy];
    
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"updated_at"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
    [posts sortUsingDescriptors:sortDescriptors];
    
    return posts;
}
#pragma mark - private methods

- (void)setWithDictionary:(NSDictionary *)organizationDictionary
{
    if ([organizationDictionary[ORGANIZATION_NAME] description]) {
        self.uid = [organizationDictionary[ORGANIZATION_ID] description];
        self.name = [organizationDictionary[ORGANIZATION_NAME] description];
        self.followers_count = [ApplicationHelper numberFromString:[organizationDictionary[ORGANIZATION_FOLLOWERS_COUNT] description]];
        self.posts_count = [ApplicationHelper numberFromString:[organizationDictionary[ORGANIZATION_POSTS_COUNT] description]];
        self.image_thumbnail_url = [organizationDictionary[ORGANIZATION_IMAGE_THUMBNAIL_URL] description];
        self.about = [organizationDictionary[ORGANIZATION_ABOUT] description];
        self.web_site_url = [organizationDictionary[ORGANIZATION_WEBSITE_URL] description];
        self.location = [organizationDictionary[ORGANIZATION_LOCATION] description];
        self.is_followed = [NSNumber numberWithBool:[organizationDictionary[ORGANIZATION_IS_FOLLOWED] boolValue]];
        
    }    
}

- (NSData *)toJSON
{
    NSDictionary *jsonDict = [self toDictionary];
    NSData *jsonData = [ApplicationHelper constructJSON:jsonDict];
    return jsonData;
}

- (NSDictionary *)toDictionary
{
    NSDictionary *organizationDictioanry = [NSDictionary dictionaryWithObjectsAndKeys:
                                            self.name, ORGANIZATION_NAME,
                                            self.location, ORGANIZATION_LOCATION,
                                            self.about, ORGANIZATION_ABOUT,
                                            self.image_thumbnail_url, ORGANIZATION_IMAGE_THUMBNAIL_URL,
                                            self.category.uid, CATEGORY , nil];
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    organizationDictioanry, ORGANIZATION, nil];
    
    return jsonDictionary;
}

@end
