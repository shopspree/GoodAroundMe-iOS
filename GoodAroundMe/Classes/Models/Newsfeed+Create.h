//
//  Newsfeed+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Newsfeed.h"

@interface Newsfeed (Create)

+ (User *)userWithDictionary:(NSDictionary *)userDictionary inManagedObjectContext:context;

@end
