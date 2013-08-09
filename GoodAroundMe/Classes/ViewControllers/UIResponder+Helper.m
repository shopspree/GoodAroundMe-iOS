//
//  UIResponder+Helper.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/6/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "UIResponder+Helper.h"

@implementation UIResponder (Helper)

- (id) traverseResponderChainForProtocol:(Protocol *)aProtocol
{
    id nextResponder = [self nextResponder];
    if ([nextResponder conformsToProtocol:aProtocol]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIResponder class]]) {
        return [nextResponder traverseResponderChainForProtocol:aProtocol];
    } else {
        return nil;
    }
}

- (id) traverseResponderChainForSelector:(SEL)aSelector
{
    id nextResponder = [self nextResponder];
    if ([nextResponder respondsToSelector:aSelector]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIResponder class]]) {
        return [nextResponder traverseResponderChainForSelector:aSelector];
    } else {
        return nil;
    }
}

@end
