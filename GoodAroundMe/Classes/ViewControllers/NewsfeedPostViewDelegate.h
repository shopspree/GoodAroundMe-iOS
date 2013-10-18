//
//  NewsfeedPostViewDelegate.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/1/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsfeedPostView.h"

@protocol NewsfeedPostViewDelegate <NSObject>

- (void)likePost:(id)sender;
- (void)commentOnPost:(id)sender;
- (void)likesOnPost:(id)sender;
- (void)goToPost:(id)sender;
- (void)goToOrganization:(id)sender;
- (void)deletePost:(id)sender;
- (void)more:(id)sender;
- (void)give:(id)sender;

@end
