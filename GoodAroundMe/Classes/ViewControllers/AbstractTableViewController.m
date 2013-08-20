//
//  AbstractTableViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/11/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AbstractTableViewController.h"
#import "UIViewController+Utility.h"
#import "StoryboardConstants.h"

@interface AbstractTableViewController ()

@end

@implementation AbstractTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performLoginIfRequired:)
                                                 name:@"Unauthorized"
                                               object:nil];
}

- (void) performLoginIfRequired:(UIViewController *)source
{
    [self navigateStoryboardWithIdentifier:SIGNUP_SIGNIN];
}

@end
