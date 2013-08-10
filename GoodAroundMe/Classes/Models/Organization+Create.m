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
            [organization setWithDictionary:organizationDictionary[ORGANIZATION]];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            organization = [matches lastObject];
        }
        
    }
    
    return organization;
}

- (void)follow:(void (^)(NSDictionary *reponseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    [OrganizationAPI follow:self.uid success:^(NSDictionary *reponseDictionary) {
        self.is_followed = [NSNumber numberWithBool:YES];
        self.followers_count = [NSNumber numberWithInteger:([self.followers_count integerValue] + 1)];
        success(reponseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}
     
- (void)unfollow:(void (^)(NSDictionary *reponseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    [OrganizationAPI unfollow:self.uid success:^(NSDictionary *reponseDictionary) {
        self.is_followed = [NSNumber numberWithBool:NO];
        self.followers_count = [NSNumber numberWithInteger:([self.followers_count integerValue] - 1)];
        success(reponseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

#pragma mark - private methods

- (void)setWithDictionary:(NSDictionary *)organizationDictionary
{
    self.uid = [organizationDictionary[ORGANIZATION_ID] description];
    self.name = [organizationDictionary[ORGANIZATION_NAME] description];
    self.followers_count = [ApplicationHelper numberFromString:[organizationDictionary[ORGANIZATION_FOLLOWERS_COUNT] description]];
    self.posts_count = [ApplicationHelper numberFromString:[organizationDictionary[ORGANIZATION_POSTS_COUNT] description]];
    self.image_thumbnail_url = [organizationDictionary[ORGANIZATION_IMAGE_THUMBNAIL_URL] description];
    self.about = [organizationDictionary[ORGANIZATION_ABOUT] description];
    self.web_site_url = [organizationDictionary[ORGANIZATION_WEBSITE_URL] description];
    self.is_followed = [NSNumber numberWithBool:[organizationDictionary[ORGANIZATION_IS_FOLLOWED] boolValue]];
        
}

@end
