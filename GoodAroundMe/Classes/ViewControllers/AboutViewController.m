//
//  AboutViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/28/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AboutViewController.h"
#import "ApplicationDictionary.h"

@interface AboutViewController ()


@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSString *)urlString
{
    if (!super.urlString) {
        ApplicationDictionary *applicationDictionary = [ApplicationDictionary sharedInstance];
        super.urlString = [applicationDictionary.dictionary objectForKey:DictionaryAboutURL];//@"http://goodaround.me";
        
    }
    
    return super.urlString;
}

@end
