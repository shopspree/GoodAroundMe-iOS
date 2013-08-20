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

+ (void)userByEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    
    [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_USER, email] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)updateUser:(User *)user success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = [user toJSON];
    
    [BaseAPI putRequestWithURL:[NSString stringWithFormat:API_USER, user.email] json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];

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

+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = [ApplicationHelper constructJSON:userDictionary];
    
    [BaseAPI postRequestWithURL:API_SIGN_UP json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
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

+ (void)signOut:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = nil;
    [BaseAPI putRequestWithURL:API_SIGN_OUT json:json success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)changePassword:(NSDictionary *)requestDictionary forEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    NSData *json = [ApplicationHelper constructJSON:requestDictionary];
    
    [BaseAPI putRequestWithURL:[NSString stringWithFormat:API_USER_CHANGE_PASSWORD, email] json:json success:^(NSDictionary *responseDictionary) {
        success(requestDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
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

+ (void)followedOrganizationsByUserEmail:(NSString *)email success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSString *message))failure
{
    [BaseAPI getRequestWithURL:API_ORGANIZATION_CATEGORIES json:nil success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}


@end
