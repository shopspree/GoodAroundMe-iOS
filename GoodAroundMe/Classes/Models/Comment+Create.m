//
//  Comment+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Comment+Create.h"
#import "User+Create.h"
#import "Post+Create.h"
#import "ApplicationHelper.h"

@implementation Comment (Create)

+ (Comment *)commentWithDictionary:(NSDictionary *)commentDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Comment *comment = nil;
    
    if (commentDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_at" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"uid = %@", [commentDictionary[COMMENT_ID] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:context];
            [comment setWithDictionary:commentDictionary];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            comment = [matches lastObject];
            [comment setWithDictionary:commentDictionary];
        }
        
    }
    
    
    return comment;
}

- (void)setWithDictionary:(NSDictionary *)commentDictionary
{
    if (YES || ! [self.updated_at compare:[ApplicationHelper dateFromString:[commentDictionary[COMMENT_UPDATED_AT] description]]]) {
        self.uid = [commentDictionary[COMMENT_ID] description];
        self.content = [commentDictionary[COMMENT_CONTENT] description];
        self.created_at = [ApplicationHelper dateFromString:[commentDictionary[COMMENT_CREATED_AT] description]];
        self.updated_at = [ApplicationHelper dateFromString:[commentDictionary[COMMENT_UPDATED_AT] description]];
        self.likes_count = [ApplicationHelper numberFromString:[commentDictionary[COMMENT_LIKES_COUNT] description]];
        self.liked_by_user = @([[commentDictionary[COMMENT_LIKED_BY_USER] description] intValue]);
    }
    
    User *user = [User userWithDictionary:commentDictionary[COMMENT_USER] inManagedObjectContext:self.managedObjectContext];
    self.user = user;
}

+ (NSDictionary *)constructJSONForContent:(NSString *)content
{
    NSMutableDictionary *jsonDict = [NSDictionary dictionaryWithObjectsAndKeys:content, COMMENT_CONTENT, nil];
    
    return jsonDict;
}

- (NSString *)description2
{
    NSString *desc = [NSString stringWithFormat:@"\n[DEBUG] Comment: uid=%@, content=%@, created_at=%@, updated_at=%@",
                      [self.uid description],
                      [self.content description],
                      [self.created_at description],
                      [self.updated_at description]];
    
    return desc;
}

@end
