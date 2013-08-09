//
//  UserAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/19/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "UserAPI.h"
#import "ApplicationHelper.h"


@implementation UserAPI

+ (void)userByEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = nil;
    
    NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_PROFILE, email] withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] response from server is %@", responseDictionary);
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)updateUser:(User *)user success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = [user toJSON];
    
    NSURLRequest *request = [BaseAPI putRequestWithURL:[NSString stringWithFormat:API_PROFILE, user.email] withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];

}

+ (void)notificationsForUser:(User *)user success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = nil;
    
    NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_NOTIFICATIONS, user.email] withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)acknowledgeNotificationsForUser:(User *)user success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = nil;
    
    NSURLRequest *request = [BaseAPI putRequestWithURL:[NSString stringWithFormat:API_NOTIFICATIONS, user.email] withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = [ApplicationHelper constructJSON:userDictionary];
    
    NSURLRequest *request = [BaseAPI postRequestWithURL:API_SIGN_UP withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            success(responseDictionary);
        } 
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)signIn:(NSDictionary *)userDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = [ApplicationHelper constructJSON:userDictionary];
    
    NSURLRequest *request = [BaseAPI postRequestWithURL:API_SIGN_IN withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            success(responseDictionary);
        } 
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)signOut:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = nil;
    
    NSURLRequest *request = [BaseAPI putRequestWithURL:API_SIGN_OUT withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)changePassword:(NSDictionary *)requestDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *json = [ApplicationHelper constructJSON:requestDictionary];
    
    NSURLRequest *request = [BaseAPI putRequestWithURL:API_CHANGE_PASSWORD withJSON:json];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    if ([keyword length] > 0) {
        NSData *json = nil;
        NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_PROFILE_SEARCH, [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [NSNumber numberWithInteger:page]] withJSON:json];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            if ([response statusCode] == 200) {
                NSDictionary *responseDictionary = (NSDictionary *)JSON;
                
                if (success) {
                    success(responseDictionary);
                }
                
            }
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"[DEBUG] [%@] %d error!!!", [[self class] description], [response statusCode]);
            
            NSDictionary *errorData = (NSDictionary *)JSON;
            failure(errorData);
        }];
        
        [operation start];
    }
}

+ (BOOL)validateLogin
{
    
}


@end
