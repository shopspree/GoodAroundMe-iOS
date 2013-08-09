//
//  Notification.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Notification : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * is_read;
@property (nonatomic, retain) NSString * post_id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) User *user;

@end
