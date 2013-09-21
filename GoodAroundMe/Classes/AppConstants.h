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

// Notifications
extern NSString *const NotificationUnauthorized;
extern NSString *const NotificationCommentsCountChanged;
extern NSString *const NotificationLikesCountChanged;

// Error messages
extern NSString *const ErrorMessageLetUsKnow;
extern NSString *const ErrorMessageWorkingToFix;

// Error codes
extern NSInteger const ErrorCodeManagedObjectContextNil;
extern NSInteger const ErrorCodeServerError500;

@interface AppConstants : NSObject

@end
