//
//  HashtagAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/11/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "HashtagAPI.h"

@implementation HashtagAPI

+ (void)hashtags:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI getRequestWithURL:API_HASHTAGS_URL withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] Response from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[ERROR] %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

@end
