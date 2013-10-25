//
//  BaseAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "BaseAPI.h"
#import "AppConstants.h"
#import "APIConstants.h"
#import "User+Create.h"


@interface BaseAPI ()

@end

@implementation BaseAPI

+ (void)getRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestGet success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)postRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestPost success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)putRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestPut success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)deleteRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    [BaseAPI serverRequestWithURL:url json:json requestType:ServerRequestDelete success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)serverRequestWithURL:(NSString *)url json:(NSData *)json requestType:(ServerRequestType)type success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSURLRequest *request;
    switch (type) {
        case ServerRequestGet:
            request = [BaseAPI requestWithURL:url withJSON:json httpMethod:HTTP_GET];
            break;
            
        case ServerRequestPost:
            request = [BaseAPI requestWithURL:url withJSON:json httpMethod:HTTP_POST];
            break;
            
        case ServerRequestPut:
            request = [BaseAPI requestWithURL:url withJSON:json httpMethod:HTTP_PUT];
            break;
            
        case ServerRequestDelete:
            request = [BaseAPI requestWithURL:url withJSON:json httpMethod:HTTP_DELETE];
            break;
            
        default:
            break;
    }
    
    [BaseAPI serverRequest:request success:^(NSDictionary *responseDictionary) {
        if (success) {
            success(responseDictionary);
        }
    } failure:^(NSString *message) {
        if (failure) {
            failure(message);
        }
    }];
}

+ (void)serverRequest:(NSURLRequest *)request success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [self setNetworkActivityIndicatorVisible:NO];
        if ([response statusCode] == 200) {
            //NSLog(@"[DEBUG] <BaseAPI> Response from server: \n %@", JSON);
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }  
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self setNetworkActivityIndicatorVisible:NO];
        NSLog(@"[DEBUG] <%@> %d error for %@!!!", [[self class] description], [response statusCode], request.URL.path);
        NSString *message = [BaseAPI error:JSON onRequest:request withStatusCode:[response statusCode]];
        failure(message);
    }];
    
    [operation start];
    [self setNetworkActivityIndicatorVisible:YES];
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
    
    NSLog(@"[DEBUG] <BaseAPI> Call for url:%@ %@", httpMethod, [url description]);
    
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

+ (NSString *)error:(NSDictionary *)errorData onRequest:(NSURLRequest *)request withStatusCode:(NSInteger)statusCode
{
    NSString *message = nil;
    
    if (statusCode == 401) {
        // check if the user is getting a 401 but is not changing password where in this process 
        if ([request.URL.absoluteString rangeOfString:@"update_password.json"].location == NSNotFound &&
            [request.URL.absoluteString rangeOfString:@"/users/sign_in.json"].location == NSNotFound) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUnauthorized object:self];
        } else {
            if ([errorData objectForKey:@"errors"]) {
                message = [errorData objectForKey:@"errors"];
            }
        }
        
    } else if (statusCode == 404) {
        message = [NSString stringWithFormat:@"Error %d: %@", ErrorCodeServerError404, ErrorMessageWorkingToFix];
        
    } else if (statusCode == 500) {
        message = [NSString stringWithFormat:@"Error %d: %@", ErrorCodeServerError500, ErrorMessageWorkingToFix];
        
    } else {
        NSString *messageTopic = @"Error with details: ";//[[errorData[@"errors"] allKeys] lastObject];
        NSString *messageContent = errorData[@"errors"];//[[errorData[@"errors"] allValues] lastObject][0];
        message = (messageTopic && messageContent) ? [NSString stringWithFormat:@"%@ %@", messageTopic, messageContent] : ErrorMessageLetUsKnow;
    }
    
    return message;
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

+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;
    
    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}


@end
