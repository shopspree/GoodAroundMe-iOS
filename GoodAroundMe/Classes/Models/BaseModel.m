//
//  BaseModel.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    return self;
}

+ (NSData *)constructJSON:(NSDictionary *)dictionary
{
    NSError *jsonSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonSerializationError];
    
    if(!jsonSerializationError) {
        NSString *serJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Serialized JSON: %@", serJSON);
    } else {
        NSLog(@"JSON Encoding Failed: %@", [jsonSerializationError localizedDescription]);
    }
    
    return jsonData;
}

- (NSDictionary *)toDictionary
{
    // abstract method
    return nil;
}

- (NSData *)toJSON
{
    NSData *jsonData = [BaseModel constructJSON:[self toDictionary]];
    return jsonData;
}

@end
