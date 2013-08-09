//
//  Notification+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/23/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Notification.h"

#define NOTIFICATION @"notification"
#define NOTIFICATION_TYPE @"type"
#define NOTIFICATION_ID @"id"
#define NOTIFICATION_POST_ID @"post_id"
#define NOTIFICATION_IS_READ @"is_read"
#define NOTIFICATION_CREATED_AT @"created_at"
#define NOTIFICATION_USER @"user"

@interface Notification (Create)

+ (Notification *)notificationWithDictionary:(NSDictionary *)notificationDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

@end
