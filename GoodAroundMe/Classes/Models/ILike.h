//
//  ILike.h
//  TempName
//
//  Created by asaf ahi-mordehai on 6/27/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ILike <NSObject>

- (void)like:(void (^)(Like *like))success failure:(void (^)(NSDictionary *errorData))failure;

@end
