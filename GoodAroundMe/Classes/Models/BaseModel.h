//
//  BaseModel.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toDictionary;
- (NSData *)toJSON;

+ (NSData *)constructJSON:(NSDictionary *)dictionary;

@end
