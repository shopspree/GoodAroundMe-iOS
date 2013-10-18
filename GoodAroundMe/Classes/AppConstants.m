//
//  AppConstants.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/15/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "AppConstants.h"

NSString *const NotificationUnauthorized = @"Unauthorized";
NSString *const NotificationCommentsCountChanged = @"CommentsCountChanged";
NSString *const NotificationLikesCountChanged = @"LikesCountChanged";

NSString *const ErrorMessageLetUsKnow =  @"Oops, an error occured. Let us know";
NSString *const ErrorMessageWorkingToFix = @"Oops, we have a problem and we are working to fix it";

NSInteger const ErrorCodeManagedObjectContextNil = 1;
NSInteger const ErrorCodeServerError500 = 2;
NSInteger const ErrorCodeServerError404 = 3;

NSString *const GoodAroundMeCache = @"GAMCache";

@implementation AppConstants

@end
