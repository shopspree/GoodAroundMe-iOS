//
//  TestVideoViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/21/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "TestVideoViewController.h"

@interface TestVideoViewController ()

@property (strong, nonatomic) MPMoviePlayerController *player;

@end

@implementation TestVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playMovie:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString:@"https://s3.amazonaws.com/GoodAroundMe/media/2013-10-19+16.25.23.mov"];
    self.player = [[MPMoviePlayerController alloc] init];
    self.player.movieSourceType = MPMovieSourceTypeStreaming;
    [self.player setContentURL:url];
    [self.player setFullscreen:NO animated:YES];
    [self.player prepareToPlay];
    CGRect bounds = CGRectMake(0, 0, 320, 269);//self.pictureImage.bounds;
    [self.player.view setFrame:bounds];  // player's frame must match parent's
    self.player.view.backgroundColor = [UIColor blueColor];
    //player.view.alpha = 0.5;
    self.player.controlStyle = MPMovieControlStyleEmbedded;
    self.player.view.tag = 555;
    UIView *viewToRemove = [self.view viewWithTag:555];
    [viewToRemove removeFromSuperview];
    [self.view addSubview:self.player.view];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.player forKey:@"player"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerLoadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:userInfo];
    
    
    
    //NSLog(@"[DEBUG] <TestVideoViewController> PLaybackMode is %@", player.playbackState == MPMoviePlaybackStatePlaying ? @"Playing" : @"Error");
}

- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification
{   
    //MPMoviePlayerController *player = [notification.userInfo objectForKey:@"player"];
    NSLog(@"loadstate change: %Xh", self.player.loadState);
    
    if ((self.player.loadState & MPMovieLoadStatePlayable) == MPMovieLoadStatePlayable)
    {
        NSLog(@"yay, it became playable");
    }
}

@end
