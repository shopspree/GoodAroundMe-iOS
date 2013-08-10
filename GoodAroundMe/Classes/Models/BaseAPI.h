//
//  BaseAPI.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation.h"
#import "APIConstants.h"

@interface BaseAPI : NSObject

typedef NS_ENUM(NSInteger, ServerRequestType) {
    ServerRequestGet,
    ServerRequestPost,
    ServerRequestPut,
    ServerRequestDelete
};

+ (void)getRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)postRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)putRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;
+ (void)deleteRequestWithURL:(NSString *)url json:(NSData *)json success:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure;


+ (NSURLRequest *)getRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData;
+ (NSURLRequest *)postRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData;
+ (NSURLRequest *)putRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData;
+ (NSURLRequest *)deleteRequestWithURL:(NSString *)urlString withJSON:(NSData *)jsonData;

@end
