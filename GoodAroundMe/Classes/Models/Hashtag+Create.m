//
//  Hashtag+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/10/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Hashtag+Create.h"
#import "ApplicationHelper.h"
#import "HashtagAPI.h"

@implementation Hashtag (Create)

+ (void)hashtags:(NSManagedObjectContext *)context success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [HashtagAPI hashtags:^(NSDictionary *responseDictionary) {
        NSArray *hashtagsArray = responseDictionary[@"hashtags"];
        for (NSDictionary *hashtagDictionary in hashtagsArray) {
            [Hashtag hashtagWithDictionary:hashtagDictionary[HASHTAG] inManagedObjectContext:context];
        }
        success();
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)search:(NSString *)keyword managedObjectContext:(NSManagedObjectContext *)context success:(void (^)(NSArray *hashtagsArray))success failure:(void (^)(NSDictionary *errorData))failure
{
    [HashtagAPI hashtags:^(NSDictionary *responseDictionary) {
        NSArray *hashtagsDictionaryArray = responseDictionary[@"hashtags"];
        for (NSDictionary *hashtagDictionary in hashtagsDictionaryArray) {
            [Hashtag hashtagWithDictionary:hashtagDictionary[HASHTAG] inManagedObjectContext:context];
        }
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hashtag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"key CONTAINS[cd] %@", keyword];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        success(matches);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (Hashtag *)hashtagWithDictionary:(NSDictionary *)hashtagDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Hashtag *hashtag = nil;
    
    if (hashtagDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hashtag"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [hashtagDictionary[HASHTAG_ID] description]]; 
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            hashtag = [NSEntityDescription insertNewObjectForEntityForName:@"Hashtag" inManagedObjectContext:context];
            [hashtag setWithDictionary:hashtagDictionary];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            hashtag = [matches lastObject];
            [hashtag setWithDictionary:hashtagDictionary];
        }
        
    }
    
    return hashtag;
}

- (void)setWithDictionary:(NSDictionary *)hashtagDictionary
{
    NSDate *serverUpdateDate = [ApplicationHelper dateFromString:[hashtagDictionary[HASHTAG_UPDATED_AT] description]];
    if (YES || ! [self.updated_at compare:serverUpdateDate]) {
        self.uid = [hashtagDictionary[HASHTAG_ID] description];
        self.key = [hashtagDictionary[HASHTAG_KEY] description];
        self.value = [hashtagDictionary[HASHTAG_VALUE] description];
        self.created_at = [ApplicationHelper dateFromString:[hashtagDictionary[HASHTAG_CREATED_AT] description]];
        self.updated_at = [ApplicationHelper dateFromString:[hashtagDictionary[HASHTAG_UPDATED_AT] description]];
    }
}

- (NSString *)description2
{
    NSString *desc = [NSString stringWithFormat:@"\n\n[DEBUG] HASHTAG uid=%@, created_at=%@, updated_at=%@, key=%@, value=%@\n",
                      [self.uid description],
                      [self.created_at description],
                      [self.updated_at description],
                      [self.key description],
                      [self.value description]];
    
    return desc;
}

@end
