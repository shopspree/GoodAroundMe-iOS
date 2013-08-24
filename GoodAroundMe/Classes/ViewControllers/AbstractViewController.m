//
//  AbstractViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "AbstractViewController.h"
#import "StoryboardConstants.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performLoginIfRequired:)
                                                 name:@"Unauthorized"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void) willEnterForeground:(NSNotification *)notification {
    //[self performLoginIfRequired:self];
}

- (void) performLoginIfRequired:(UIViewController *)source {
    [self navigateStoryboardWithIdentifier:SIGNUP_SIGNIN];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setManagedObjectContext::)]) {
        [segue.destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
    }
}

@end
