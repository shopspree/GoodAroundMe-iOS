//
//  Group+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Group.h"

#define GROUP_NAME @"name"

@interface Group (Create)

+ (Group *)groupWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
