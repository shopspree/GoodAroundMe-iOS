//
//  AppConstants.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SERVER_GENERIC_API_KEY @""
#define SERVER_PROTOCOL @"http"
#define SERVER_HOST @"goodaroundme.herokuapp.com"
#define SERVER_PORT @"80"

#define NOTIFICATION_HTTP_401 @"Unauthorized" 

extern NSString *const NotificationUnauthorized;
extern NSString *const NotificationCommentsCountChanged;
extern NSString *const NotificationLikesCountChanged;

@interface AppConstants : NSObject

@end
