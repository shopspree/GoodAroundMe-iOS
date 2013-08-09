//
//  Profile.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseModel.h"

@interface Profile : BaseModel

#define PROFILE_EMAIL_KEY @"email"
#define PROFILE_FIRST_NAME @"first_name"
#define PROFILE_LAST_NAME @"last_name"

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *email;

+ (BOOL)validateName:(NSString *)name;

@end
