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

- (void)newsfeedForOrganization:(void (^)())success
                        failure:(void (^)(NSString *message))failure
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

@end
