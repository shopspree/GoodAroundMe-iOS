//
//  CategoryAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/16/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CategoryAPI.h"

@implementation CategoryAPI

+ (void)categories:(void (^)(NSDictionary *responseDictionary))success
           failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI getRequestWithURL:API_ORGANIZATIONS_CATEGORIES withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] (categories) Response from server: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] (categories) %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

@end
