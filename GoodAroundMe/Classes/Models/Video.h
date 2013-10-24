//
//  Video.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/22/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Media.h"


@interface Video : Media

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * image_url;

@end
