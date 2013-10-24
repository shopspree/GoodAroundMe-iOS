//
//  Photo+Create.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Photo+Create.h"
#import "Post+Create.h"
#import "ApplicationHelper.h"

@implementation Photo (Create)

+ (Photo *)photoWithDictionary:(NSDictionary *)photoDictionary  post:(Post *)post
{
    Photo *photo = nil;
    
    if (photoDictionary) {
        NSManagedObjectContext *context = post.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [photoDictionary[PHOTO_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else {
            if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
                photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            } else { // found the Photo, just return it from the list of matches (which there will only be one of)
                photo = [matches lastObject];
            }
            
            [photo setWithDictionary:photoDictionary];
        }
    }
    
    return photo;
}

- (void)setWithDictionary:(NSDictionary *)photoDictionary
{
    
    self.uid = [photoDictionary[PHOTO_ID] description];
    self.image_url = [photoDictionary[PHOTO_URL] description];
    self.created_at = [ApplicationHelper dateFromString:[photoDictionary[PHOTO_CREATED_AT] description]];
    self.updated_at = [ApplicationHelper dateFromString:[photoDictionary[PHOTO_UPDATED_AT] description]];
}

@end
