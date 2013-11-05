//
//  GiveViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/11/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "GiveViewController.h"
#import "AppConstants.h"
#import "ApplicationDictionary.h"
#import "Organization.h"

@interface GiveViewController () <UIWebViewDelegate>

@end

@implementation GiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"[DEBUG] <GiveViewController> Open give url %@ for organization %@", self.urlString, self.organization.name);
}

- (NSString *)urlString
{
    if (!self.urlString) {
        ApplicationDictionary *applicationDictionary = [ApplicationDictionary sharedInstance];
        super.urlString = [applicationDictionary.dictionary objectForKey:DictionaryGiveURL];//@"http://goodaround.me";
    }
    
    return super.urlString;
}

@end
