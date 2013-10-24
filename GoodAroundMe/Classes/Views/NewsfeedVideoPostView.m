//
//  NewsfeedVideoPost.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "NewsfeedVideoPostView.h"

@interface NewsfeedVideoPost()

@property (strong, nonatomic) MPMoviePlayerController *player;

@end

@implementation NewsfeedVideoPost

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)playVideo
{
    NSURL *url = [[NSURL alloc] initWithString:@"https://s3.amazonaws.com/GoodAroundMe/media/2013-10-19+16.25.23.mov"];
    self.player = [[MPMoviePlayerController alloc] init];
    self.player.movieSourceType = MPMovieSourceTypeStreaming;
    [self.player setContentURL:url];
    [self.player setFullscreen:NO animated:YES];
    [self.player prepareToPlay];
    
    // adding the player to the view
    CGRect bounds = self.imageView.bounds;
    [self.player.view setFrame:bounds];  // player's frame must match parent's
    self.player.view.backgroundColor = [UIColor lightGrayColor];
    self.player.controlStyle = MPMovieControlStyleEmbedded;
    self.player.view.tag = 555;
    UIView *viewToRemove = [self.mediaContainerView viewWithTag:555];
    [viewToRemove removeFromSuperview];
    [self.mediaContainerView addSubview:self.player.view];
}


@end
