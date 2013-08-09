//
//  Picture.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Post;

@interface Picture : NSManagedObject

@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Post *post;

@end
