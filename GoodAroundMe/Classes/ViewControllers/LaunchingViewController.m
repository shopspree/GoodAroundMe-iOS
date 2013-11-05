//
//  LaunchingViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/17/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "LaunchingViewController.h"
#import "OrganizationCategory+Create.h" 
#import "User+Create.h"
#import "OrganizationCategory.h"
#import "StoryboardConstants.h"
#import "CoreDataFactory.h"
#import "MetadataAPI.h"
#import "ApplicationDictionary.h"

@interface LaunchingViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation LaunchingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.managedObjectContext) {
        [self launch];
    } else {
        [self initiliaze];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
   self.navigationController.navigationBarHidden = NO;
}

- (void)initiliaze
{
    [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
        self.managedObjectContext = managedObjectContext;
        [self launch];
    }];
}

- (void)launch
{
    [self.activityIndicator startAnimating];
    
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL];
    NSString *authToken = [[NSUserDefaults standardUserDefaults] stringForKey:USER_AUTHENTICATION];
    
    if (email && authToken) {
        [self loadUser];
    } else {
        NSLog(@"[DEBUG] <LaunchingViewController> Authentication credentials missing: \n\temail: %@ \n\tauthentication token: %@", email, authToken);
        [self performSegueWithIdentifier:STORYBOARD_SIGNUP_SIGNIN sender:self];
    }
}

- (void)loadUser
{
    NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:USER_EMAIL];
    if (!email) {
        [self performSegueWithIdentifier:STORYBOARD_SIGNUP_SIGNIN sender:self];
    } else {
        [User userByEmail:email inManagedObjectContext:self.managedObjectContext success:^(User *user) {
            [self LoadDictionary];
        } failure:^(NSString *message) {
            [self fail:@"Good Around Me" withMessage:message];
        }];
    }
}

- (void)LoadDictionary
{
    ApplicationDictionary *applicationDictionary = [ApplicationDictionary sharedInstance];
    [applicationDictionary loadDictionary:^{
        [self loadCategories];
    } failure:^(NSString *message) {
        [self fail:@"Good Around Me" withMessage:message];
    }];
}

- (void)loadCategories
{
    [OrganizationCategory categories:self.managedObjectContext success:^(NSArray *categories) {
        NSLog(@"[DEBUG] <LaunchingViewController> Categories received. Caching categories images");
        [self cacheCategoryImages:categories];
        
        NSLog(@"[DEBUG] <LaunchingViewController> Everything is normal, performing Modal segue to Newsfeed");
        [self performSegueWithIdentifier:STORYBOARD_NEWSFEED sender:self];
        
        [self.activityIndicator stopAnimating];
        
    } failure:^(NSString *message) {
        [self fail:@"Good Around Me" withMessage:@"Error loading application"];
        [self.activityIndicator stopAnimating];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    NSLog(@"[DEBUG] <LaunchingViewController> Perform segue to %@", segue.identifier);
}

- (IBAction)unwindFromUserAuthentication:(UIStoryboardSegue *)segue
{
    //[self launch];
}

- (void)cacheCategoryImages:(NSArray *)categories
{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    
    for (OrganizationCategory *category in categories) {
        // check if image is found in cache
        if ([imageCache imageFromDiskCacheForKey:category.imageURL]) {
            NSLog(@"[DEBUG] <LaunchingViewController> Found image in Disk cache for category %@", category.name);
        } else { //image was not found in cache - download it
            NSURL *imageURL = [NSURL URLWithString:category.imageURL];
            UIImage *categoryImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
            NSLog(@"[DEBUG] <LaunchingViewController> Download image for category %@ succesful", category.name);
            
            [imageCache storeImage:categoryImage forKey:category.imageURL toDisk:YES];
            NSLog(@"[DEBUG] <LaunchingViewController> Cache image for category %@ succesful", category.name);
        }
    }
}

@end
