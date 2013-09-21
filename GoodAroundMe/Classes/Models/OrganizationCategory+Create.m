//
//  OrganizationCategory+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "OrganizationCategory+Create.h"
#import "CategoryAPI.h"
#import "CoreDataFactory.h"
#import "Organization+Create.h"

@implementation OrganizationCategory (Create)

+ (OrganizationCategory *)categoryWithDictionary:(NSDictionary *)categoryDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    OrganizationCategory *category = nil;
    
    if (categoryDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrganizationCategory"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", [categoryDictionary[CATEGORY_NAME] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            NSLog(@"[ERROR] <OrganizationCategory+Create> Error fetching category by name %@", [categoryDictionary[CATEGORY_NAME] description]);
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            category = [NSEntityDescription insertNewObjectForEntityForName:@"OrganizationCategory" inManagedObjectContext:context];
            [category setWithDictionary:categoryDictionary];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            category = [matches lastObject];
            [category setWithDictionary:categoryDictionary];
        }
        
    }
    
    return category;
}

+ (NSArray *)categories:(NSManagedObjectContext *)managedObjectContext success:(void (^)(NSArray *categories))success failure:(void (^)(NSString *message))failure
{
    NSArray *categories = [OrganizationCategory categories:managedObjectContext];
    
    // fetch categories from the server
    [OrganizationCategory categoriesFromServer:managedObjectContext success:^() {
        NSArray *categories = [OrganizationCategory categories:managedObjectContext];
        success(categories);
    } failure:^(NSString *message) {
        failure(message);
    }];
    
    return categories;
}

+ (NSArray *)categories:(NSManagedObjectContext *)managedObjectContext
{
    NSArray *categories = [NSArray array];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"OrganizationCategory"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = nil; // all categories
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    
    categories = matches;
    
    return categories;
}
    
+ (void)categoriesFromServer:(NSManagedObjectContext *)managedObjectContext success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [CategoryAPI categories:^(NSDictionary *responseDictionary) {
        NSMutableArray *categories = [NSMutableArray array];
        for (NSDictionary *categoryDictionary in responseDictionary[@"organization_categories"]) {
            OrganizationCategory *category = [OrganizationCategory categoryWithDictionary:categoryDictionary[CATEGORY] inManagedObjectContext:managedObjectContext];
            [categories addObject:category];
        }
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

#pragma mark - private methods

- (void)setWithDictionary:(NSDictionary *)categoryDictionary
{
    self.uid = [categoryDictionary[CATEGORY_ID] description];
    self.name = [categoryDictionary[CATEGORY_NAME] description];
    self.imageURL = [categoryDictionary[CATEGORY_IMAGE_URL] description];
    
    NSArray *organizationsArray = categoryDictionary[CATEGORY_ORGANIZATIONS];
    for (NSDictionary *organizationDictionary in  organizationsArray) {
        Organization *organization = [Organization organizationWithDictionary:organizationDictionary[ORGANIZATION] inManagedObjectContext:self.managedObjectContext];
        [self addOrganizationsObject:organization];
    }
}

@end
