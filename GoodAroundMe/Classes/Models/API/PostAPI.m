//
//  PostAPI.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/27/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "ApplicationHelper.h"
#import "PostAPI.h"
#import "Comment+Create.h"
#import "Like+Create.h"

@implementation PostAPI

+ (void)post:(NSString *)postID
     success:(void (^)(NSDictionary *responseDictionary))success
     failure:(void (^)(NSDictionary *errorData))failure
{
    
    NSData *jsonData = nil;
    
    NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_SHOW, postID] withJSON:jsonData];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [%@] Response from server is: %@", [[self class] description], responseDictionary);
            
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

+ (void)newPost:(NSDictionary *)postDictionary
        success:(void (^)(NSDictionary *responseDictionary))success
        failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *jsonData = [PostAPI jsonRequestForPost:postDictionary];
    
    NSURLRequest *request = [BaseAPI postRequestWithURL:API_POST withJSON:jsonData];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [%@] Response from server is: %@", [[self class] description], responseDictionary);
            
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

+ (void)deletePost:(Post *)post
           success:(void (^)())success
           failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_POST_DELETE, post.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSLog(@"[DEBUG] (likePost)Response code from server is: %d", [response statusCode]);
            
            if (success) {
                success();
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] (likePost) %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
}

+ (void)popular:(void (^)(NSDictionary *responseDictionary))success failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *jsonData = nil;
    
    NSURLRequest *request = [BaseAPI getRequestWithURL:API_POST_POPULAR withJSON:jsonData];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [%@] Response from server is: %@", [[self class] description], responseDictionary);
            
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

+ (void)likesOnPost:(Post *)post
         success:(void (^)(NSDictionary *responseDictionary))success
         failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_LIKES, post.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [likesOnPost] Response from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] [likePost] %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)likePost:(Post *)post
         success:(void (^)(NSDictionary *responseDictionary))success
         failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_POST_LIKE, post.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [likePost)Response] from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] (likePost) %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)unlike:(Like *)like post:(Post *)post
         success:(void (^)(NSDictionary *responseDictionary))success
         failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_POST_UNLIKE, post.uid, like.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] (likePost)Response from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] (likePost) %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)commentsOnPost:(Post *)post
        success:(void (^)(NSDictionary *responseDictionary))success
        failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI getRequestWithURL:[NSString stringWithFormat:API_POST_COMMENTS, post.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [%@] Response from server is: %@", [[self class] description], responseDictionary);
            
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

+ (void)comment:(NSString *)content onPost:(Post *)post
         success:(void (^)(NSDictionary *responseDictionary))success
         failure:(void (^)(NSDictionary *errorData))failure
{
    NSData *jsonData = [PostAPI jsonRequestForComment:content onPost:post];
    
    NSURLRequest *request = [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_POST_COMMENT, post.uid] withJSON:jsonData];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] [%@] Response from server is: %@", [[self class] description], responseDictionary);
            
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

+ (void)deleteComment:(Comment *)comment onPost:(Post *)post
       success:(void (^)(NSDictionary *responseDictionary))success
       failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI deleteRequestWithURL:[NSString stringWithFormat:API_POST_COMMENT_DELETE, post.uid, comment.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSDictionary *responseDictionary = (NSDictionary *)JSON;
            NSLog(@"[DEBUG] (deleteComment)Response from server is: %@", responseDictionary);
            
            if (success) {
                success(responseDictionary);
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] (deleteComment) %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

+ (void)inappropriatePost:(Post *)post
         success:(void (^)())success
         failure:(void (^)(NSDictionary *errorData))failure
{
    NSURLRequest *request = [BaseAPI postRequestWithURL:[NSString stringWithFormat:API_POST_INAPPROPRIATE, post.uid] withJSON:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if ([response statusCode] == 200) {
            NSLog(@"[DEBUG] (likePost)Response status code from server is: %d", [response statusCode]);
            
            if (success) {
                success();
            }
            
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"[DEBUG] (likePost) %d error!!!", [response statusCode]);
        
        NSDictionary *errorData = (NSDictionary *)JSON;
        failure(errorData);
    }];
    
    [operation start];
    
}

#pragma mark - private methods

+ (NSData *)jsonRequestForPost:(NSDictionary *)postDictionary
{
    NSData *jsonData = [ApplicationHelper constructJSON:postDictionary];
    return jsonData;
}

+ (NSData *)jsonRequestForComment:(NSString *)content onPost:(Post *)post
{
    NSDictionary *dataDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:post.uid, @"post_id",
                              [Comment constructJSONForContent:content], @"comment",
                              nil];
    NSData *jsonData = [ApplicationHelper constructJSON:dataDict];
    return jsonData;
}

@end
