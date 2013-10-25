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
#import "GAI.h"
#import "GAITracker.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface AbstractTableViewController ()

@property (nonatomic, strong) UIBarButtonItem *rightBarButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AbstractTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(performLoginIfRequired:)
                                                 name:@"Unauthorized"
                                               object:nil];
    
    //[self gaiManualScreenMeasurement];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}


- (void)gaiManualScreenMeasurement
{
    // Google Analytics
    UIViewController *currentVC = self.navigationController.visibleViewController;
    NSString *screenName = [[currentVC class] description];
    
    // May return nil if a tracker has not already been initialized with a
    // property ID.
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:screenName];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}


- (void) performLoginIfRequired:(UIViewController *)source
{
    [self navigateStoryboardWithIdentifier:STORYBOARD_LANDING_PAGE];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"[DEBUG] <%@> Segue to %@", [self currentViewController], [segue.destinationViewController class]);
    
    UIViewController *destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)destinationViewController;
        destinationViewController = navigationController.viewControllers[0];
    }
    
    if ([destinationViewController respondsToSelector:@selector(setManagedObjectContext:)]) {
        [destinationViewController performSelector:@selector(setManagedObjectContext:) withObject:self.managedObjectContext];
        if (!self.managedObjectContext) {
            NSLog(@"[ERROR] <%@> Self managedObjectContext is empty on segue from %@", [self currentViewController], segue.identifier);
        }
    } 
}

- (void)startActivityIndicationInNavigationBar
{
    self.rightBarButton = self.navigationItem.rightBarButtonItem;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.navigationItem.rightBarButtonItem = barButton;
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicationInNavigationBar
{
    [self.activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = self.rightBarButton;
}

@end
