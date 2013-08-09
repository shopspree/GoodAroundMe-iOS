//
//  AbstractViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/21/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "AbstractViewController.h"

@interface AbstractViewController ()

@end

@implementation AbstractViewController

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
    
    self.navigationController.navigationBarHidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fail:(NSString *)title withMessage:(NSString *)message
{
    if (title && message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        
    }
}

- (void) willEnterForeground:(NSNotification *)notification {
    [self performLoginIfRequired:self];
}

- (void) performLoginIfRequired: (UIViewController *) source {
    
    if (NO) {
        
        NSLog(@"Is not authed");
        
        //UIStoryboard *storyboard = [UIApplication sharedApplication].delegate.window.rootViewController.storyboard;
        //UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
        
        //[self presentViewController:nil animated:YES completion:^{ }];
        [self performSegueWithIdentifier:@"SignUpSignIn" sender:self];
        
    } else {
        NSLog(@"Is authe");
        
    }
}

- (BOOL)validateLogin
{
    BOOL login = false;
    
    
    
    return login;
}

@end
