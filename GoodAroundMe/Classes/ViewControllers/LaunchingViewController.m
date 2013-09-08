//
//  LaunchingViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/17/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "LaunchingViewController.h"
#import "OrganizationCategory+Create.h" 
#import "User+Create.h"
#import "StoryboardConstants.h"
#import "CoreDataFactory.h"

@interface LaunchingViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LaunchingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.activityIndicator startAnimating];
    
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_AUTHENTICATION];
    
    if (email && authToken) {
        [self loadUser];
    } else {
        NSLog(@"[DEBUG] User has no stored mail, performing Modal segue to Sign In Sign Up");
        [self performSegueWithIdentifier:SIGNUP_SIGNIN sender:self];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBarHidden = NO;
}

- (void)loadCategories
{  
    [OrganizationCategory categories:self.managedObjectContext success:^(NSArray *categories) {
        NSLog(@"[DEBUG] <LaunchingViewController> Everything is normal, performing Modal segue to Newsfeed");
        [self performSegueWithIdentifier:NEWSFEED sender:self];
        
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSString *message) {
        [self fail:@"Good Around Me" withMessage:@"Error loading application"];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)loadUser
{
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL];
    if (!email) {
        [self performSegueWithIdentifier:SIGNUP_SIGNIN sender:self];
    } else {
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            [User userByEmail:email inManagedObjectContext:managedObjectContext success:^(User *user) {
                self.managedObjectContext = managedObjectContext;
                [self loadCategories];
                
            } failure:^(NSString *message) {
                [self fail:@"Good Around Me" withMessage:message];
                
            }];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}

@end
