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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[DEBUG] <AbstractTableViewController> Segue to %@", [segue.destinationViewController class]);
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)destinationViewController;
        destinationViewController = navigationController.viewControllers[0];
    }
    
    if ([destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
        [destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
        if (!self.managedObjectContext) {
            NSLog(@"[ERROR] <AbstractTableViewController> Self managedObjectContext is empty on segue from %@", segue.identifier);
        }
    } 
}

@end
