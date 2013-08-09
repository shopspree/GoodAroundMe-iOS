//
//  ApplicationHelper.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationHelper : NSObject

+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSNumber *)numberFromString:(NSString *)numberString;
+ (NSString *)timeSinceNow:(NSDate *)date;
+ (NSData *)constructJSON:(NSDictionary *)dictionary;

@end
