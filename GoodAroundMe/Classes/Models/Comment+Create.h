//
//  Comment+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Comment.h"

#define COMMENT @"comment"
#define COMMENT_ID @"id"
#define COMMENT_CONTENT @"content"
#define COMMENT_CREATED_AT @"created_at"
#define COMMENT_UPDATED_AT @"updated_at"
#define COMMENT_LIKED_BY_USER @"liked_by_user"
#define COMMENT_LIKES_COUNT @"likes_count"
#define COMMENT_COMMENTABLE_ID @"commentable_id"
#define COMMENT_COMMENTABLE_TYPE @"commentable_type"
#define COMMENT_USER @"user"

@interface Comment (Create)

+ (Comment *)commentWithDictionary:(NSDictionary *)commentDictionary inManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSData *)constructJSONForContent:(NSString *)content;

- (void)setWithDictionary:(NSDictionary *)commentDictionary;
- (NSString *)getContentText;

@end
