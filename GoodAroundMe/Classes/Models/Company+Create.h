//
//  Company+Create.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "Company.h"

@interface Company (Create)

+ (Company *)companyWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;

@end
