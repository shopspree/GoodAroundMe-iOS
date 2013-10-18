//
//  Picture+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Picture+Create.h"
#import "Post+Create.h"
#import "ApplicationHelper.h"

@implementation Picture (Create)

+ (Picture *)pictureWithDictionary:(NSDictionary *)pictureDictionary  post:(Post *)post
{
    Picture *picture = nil;
    
    if (pictureDictionary) {
        NSManagedObjectContext *context = post.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Picture"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [pictureDictionary[PICTURE_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else {
            if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
                picture = [NSEntityDescription insertNewObjectForEntityForName:@"Picture" inManagedObjectContext:context];
            } else { // found the Photo, just return it from the list of matches (which there will only be one of)
                picture = [matches lastObject];
            }
            
            [picture setWithDictionary:pictureDictionary];
        }
    }
    
    return picture;
}

- (void)setWithDictionary:(NSDictionary *)pictureDictionary
{
    
    self.uid = [pictureDictionary[PICTURE_ID] description];
    self.url = [pictureDictionary[PICTURE_URL] description];
    self.created_at = [ApplicationHelper dateFromString:[pictureDictionary[PICTURE_CREATED_AT] description]];
    self.updated_at = [ApplicationHelper dateFromString:[pictureDictionary[PICTURE_UPDATED_AT] description]];
}

@end
