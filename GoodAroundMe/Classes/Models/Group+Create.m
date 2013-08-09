//
//  Group+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Group+Create.h"

@implementation Group (Create)

+ (Group *)groupWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Group *group = nil;
    
    if (name) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Group"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            group = [NSEntityDescription insertNewObjectForEntityForName:@"Group" inManagedObjectContext:context];
            group.name = name;
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            group = [matches lastObject];
        }
        
    }
    
    return group;
}

@end
