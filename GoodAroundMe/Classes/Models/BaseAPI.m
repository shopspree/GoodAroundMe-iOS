//
//  BaseAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"
#import "APIConstants.h"
#import "User+Create.h"


@interface BaseAPI ()

@end

@implementation BaseAPI

+ (void)getRequestWithURL:(NSString *)url json:(NSData *)json requestType:(ServerRequestType)type success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestGet success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)postRequestWithURL:(NSString *)url json:(NSData *)json requestType:(ServerRequestType)type success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestPost success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)putRequestWithURL:(NSString *)url json:(NSData *)json requestType:(ServerRequestType)type success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestPut success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)deleteRequestWithURL:(NSString *)url json:(NSData *)json requestType:(ServerRequestType)type success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestDelete success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)serverRequestWithURL:(NSString *)url json:(NSData *)json requestType:(ServerRequestType)type success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request;
    switch (type) {
        case ServerRequestGet:
            request = [BaseAPI getRequestWithURL:url withJSON:json];
            break;
            
        case ServerRequestPost:
            request = [BaseAPI postRequestWithURL:url withJSON:json];
            break;
            
        case ServerRequestPut:
            request = [BaseAPI putRequestWithURL:url withJSON:json];
            break;
            
        case ServerRequestDelete:
            request = [BaseAPI deleteRequestWithURL:url withJSON:json];
            break;
            
        default:
            break;
    }
    
    [BaseAPI serverRequest:request success:^(NSDictionary *responseDictionary) {
        if (success) {
            success(responseDictionary);
        }
    } failure:^(NSDictionary *errorData) {
        if (failure) {
            failure(errorData);
        }
    }];
}

+ (void)serverRequest:(NSURLRequest *)request success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }
            
        } else if ([response statusCode] == 401) {
            [BaseAPI clientError:[response statusCode]];
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (NSURLRequest *)getRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData
{
    return [BaseAPI requestWithURL:urlString withJSON:jsonData httpMethod:HTTP_GET];
}

+ (NSURLRequest *)postRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData
{
    return [BaseAPI requestWithURL:urlString withJSON:jsonData httpMethod:HTTP_POST];
}

+ (NSURLRequest *)putRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData
{
    return [BaseAPI requestWithURL:urlString withJSON:jsonData httpMethod:HTTP_PUT];
}

+ (NSURLRequest *)deleteRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData
{
    return [BaseAPI requestWithURL:urlString withJSON:jsonData httpMethod:HTTP_DELETE];
}


+ (NSURLRequest *)requestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData httpMethod:(NSString *)httpMethod
{
    NSString *authToken = [self authToken];
    if (authToken) {
        NSString *urlFormat = ([urlString rangeOfString:@"?"].location == NSNotFound) ? @"%@?auth_token=%@" : @"%@&auth_token=%@";
        urlString = [NSString stringWithFormat:urlFormat, urlString, authToken];
    }
    NSURL *url = [NSURL URLWithString:[BaseAPI urlForAPI:urlString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:DEFAULT_TIMEOUT];
    [request setHTTPMethod:httpMethod];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: jsonData];
    
    NSLog(@"[BaseAPI] call for url: %@", [url description]);
    
    return request;
}

+ (NSString *)authToken
{
    NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_AUTHENTICATION];
    if ([authToken isEqualToString:@"(null)"]) {
        authToken = nil;
    }
    
    return authToken;
}

+ (NSString *)baseURL
{
    NSString *url = [NSString stringWithFormat:@"%@://%@:%@", SERVER_PROTOCOL, SERVER_HOST, SERVER_PORT];
    
    return url;
}

+ (NSString *)urlForAPI:(NSString *)apiURL
{
    return [NSString stringWithFormat:@"%@%@", [BaseAPI baseURL], apiURL];
}

+ (void)clientError:(NSInteger)statusCode
{
    switch (statusCode) {
        case 401:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Unauthorized" object:self];
            break;
            
        default:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClientError" object:self];
            break;
    }
    
}


@end
