//
//  APIConstants.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/20/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_TIMEOUT 60.0

#define HTTP_GET    @"GET"
#define HTTP_POST   @"POST"
#define HTTP_PUT    @"PUT"
#define HTTP_DELETE @"DELETE"

#define API_FORMAT @"json"

#define API_SIGN_UP                     @"/users.json"
#define API_SIGN_IN                     @"/users/sign_in.json"
#define API_SIGN_OUT                    @"/users/sign_out.json"
#define API_ACTIVITIES_URL              @"/api/v1/activities.json"
#define API_ACTIVITY_URL                @"/api/v1/activities/%@.json"
#define API_POST                        @"/api/v1/posts.json"
#define API_POST_POPULAR                @"/api/v1/posts/popular.json"
#define API_POST_ACTIVITY               @"/api/v1/posts/%@/activities.json"
#define API_POST_SHOW                   @"/api/v1/posts/%@.json"
#define API_POST_DELETE                 @"/api/v1/posts/%@.json"
#define API_POST_LIKES                  @"/api/v1/posts/%@/likes.json"
#define API_POST_LIKE                   @"/api/v1/posts/%@/likes.json"
#define API_POST_UNLIKE                 @"/api/v1/posts/%@/likes/%@.json"
#define API_POST_COMMENTS               @"/api/v1/posts/%@/comments.json"
#define API_POST_COMMENT                @"/api/v1/posts/%@/comments.json"
#define API_POST_COMMENT_DELETE         @"/api/v1/posts/%@/comments/%@.json"
#define API_POST_INAPPROPRIATE          @"/api/v1/posts/%@/inappropriate.json"
#define API_CATEGORIES                  @"/api/v1/categories.json"
#define API_CATEGORY_SUBCATEGORIES      @"/api/v1/categories/%@/subcategories.json"
#define API_SUBCATEGORIES               @"/api/v1/subcategories.json"
#define API_HASHTAGS_URL                @"/api/v1/hashtags.json"
#define API_USER                        @"/api/v1/users/%@.json"
#define API_USER_CHANGE_PASSWORD        @"/api/v1/users/%@/update_password.json"
#define API_PROFILE_SEARCH              @"/api/v1/profiles/search/%@.json?page=%@"
#define API_NOTIFICATIONS               @"/api/v1/notifications/%@.json"
#define API_ORGANIZATION_CATEGORIES     @"/api/v1/organization_categories.json"
#define API_ORGANIZATION_FOLLOW         @"/api/v1/organizations/%@/follow.json"
#define API_ORGANIZATION_UNFOLLOW       @"/api/v1/organizations/%@/unfollow.json"
#define API_ORGANIZATION_NEWSFEED       @"/api/v1/organizations/%@/activities.json"
#define API_ORGANIZATION_POSTS          @"/api/v1/organizations/%@/posts.json"
#define API_ORGANIZATION_CREATE         @"/api/v1/organization_categories/%@/organizations.json"
#define API_ORGANIZATION_UPDATE         @"/api/v1/organizations/%@.json"
#define API_ORGANIZATION_FOLLOWERS      @"/api/v1/organizations/%@/followers.json"
#define API_PROBLEMS_CREATE             @"/api/v1/problems.json"






@interface APIConstants : NSObject

@end
