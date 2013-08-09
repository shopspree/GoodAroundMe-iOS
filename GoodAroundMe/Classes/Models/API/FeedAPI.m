//
//  FeedAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "FeedAPI.h"
#import "BaseModel.h"
#import "Newsfeed+Activity.h"

@implementation FeedAPI

+ (void)postNewsfeed:(NSString *)postId success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_ACTIVITY, postId] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [FeedAPI][postNewsfeed] Response from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [FeedAPI][newsfeeds] %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)newsfeeds:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI getRequestWithURL:API_ACTIVITIES_URL withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [FeedAPI][newsfeeds] Response from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [FeedAPI][newsfeeds] %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)newsfeed:(NSString *)newsfeedID success:(void (^)(NSDictionary *newsfeedDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    
}


@end
