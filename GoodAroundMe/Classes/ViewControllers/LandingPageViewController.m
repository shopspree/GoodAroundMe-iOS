//
//  LandingPageViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/17/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "LandingPageViewController.h"
#import "Category+Create.h" 
#import "User+Create.h"
#import "StoryboardConstants.h"
#import "CoreDataFactory.h"

@interface LandingPageViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LandingPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.activityIndicator startAnimating];
    [self loadUser];
}

- (void)loadCategories
{  
    [Category categories:^(NSArray *categories) {
        
        NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL];
        if (!email) {
            NSLog(@"[DEBUG] User has no stored mail, performing Modal segue to Sign In Sign Up");
            [self performSegueWithIdentifier:SIGNUP_SIGNIN sender:self];
        } else {
            NSLog(@"[DEBUG] Everything is normal, performing Modal segue to Newsfeed");
            [self performSegueWithIdentifier:NEWSFEED sender:self];
        }
        
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
        //[self navigateStoryboardWithIdentifier:SIGNUP_SIGNIN];
        [self performSegueWithIdentifier:SIGNUP_SIGNIN sender:self];
    } else {
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            [User userByEmail:email inManagedObjectContext:managedObjectContext success:^(User *user) {
                self.managedObjectContext = managedObjectContext;
                [self loadCategories];
                
            } failure:^(NSString *message) {
                [self fail:@"Good Around Me" withMessage:@"Error loading application"];
                
            }];
        }];
    }
}

@end
