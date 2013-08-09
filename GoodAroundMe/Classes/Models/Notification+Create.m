//
//  Notification+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/23/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Notification+Create.h"
#import "ApplicationHelper.h"

@implementation Notification (Create)

+ (Notification *)notificationWithDictionary:(NSDictionary *)notificationDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Notification *notification = nil;
    
    if (notificationDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [notificationDictionary[NOTIFICATION_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            notification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
            [notification setWithDictionary:notificationDictionary];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            notification = [matches lastObject];
            [notification setWithDictionary:notificationDictionary];
        }
        
    }
    
    return notification;
}

- (void)setWithDictionary:(NSDictionary *)notificationDictionary
{
    self.uid = [notificationDictionary[NOTIFICATION_ID] description];
    self.is_read = [NSNumber numberWithBool:[[notificationDictionary[NOTIFICATION_IS_READ] description] boolValue]];
    self.post_id = [notificationDictionary[NOTIFICATION_POST_ID] description];
    self.type = [notificationDictionary[NOTIFICATION_TYPE] description];
    self.created_at = [ApplicationHelper dateFromString:[notificationDictionary[NOTIFICATION_CREATED_AT] description]];
}

@end
