//
//  Video+Create.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Video+Create.h"
#import "Post+Create.h"
#import "ApplicationHelper.h"

@implementation Video (Create)

+ (Video *)videoWithDictionary:(NSDictionary *)videoDictionary  post:(Post *)post
{
    Video *video = nil;
    
    if (videoDictionary) {
        NSManagedObjectContext *context = post.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Video"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [videoDictionary[VIDEO_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else {
            if (![matches count]) { // none found, so let's create a video for that Flickr video
                video = [NSEntityDescription insertNewObjectForEntityForName:@"Video" inManagedObjectContext:context];
            } else { // found the video, just return it from the list of matches (which there will only be one of)
                video = [matches lastObject];
            }
            
            [video setWithDictionary:videoDictionary];
        }
    }
    
    return video;
}

- (void)setWithDictionary:(NSDictionary *)videoDictionary
{
    
    self.uid = [videoDictionary[VIDEO_ID] description];
    self.url = [videoDictionary[VIDEO_URL] description];
    self.image_url = [videoDictionary[VIDEO_IMAGE_URL] description];
    self.created_at = [ApplicationHelper dateFromString:[videoDictionary[VIDEO_CREATED_AT] description]];
    self.updated_at = [ApplicationHelper dateFromString:[videoDictionary[VIDEO_UPDATED_AT] description]];
}

@end
