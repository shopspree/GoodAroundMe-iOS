//
//  UIResponder+Helper.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/6/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Helper)

- (id) traverseResponderChainForProtocol:(Protocol *)aProtocol;
- (id) traverseResponderChainForSelector:(SEL)aSelector;

@end
