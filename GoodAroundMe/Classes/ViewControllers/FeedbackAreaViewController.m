//
//  FeedbackAreaViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/12/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "FeedbackAreaViewController.h"

@interface FeedbackAreaViewController ()

@property (strong, nonatomic) NSArray *areas;

@end

@implementation FeedbackAreaViewController

- (NSArray *)areas
{
    if (!_areas) {
        _areas = [NSArray arrayWithObjects:
                  @"Launch page",           @"Choose sign in/sign up",          @"Sign in"          @"Sign up",
                  @"Explore",               @"Organizations under category",    @"Main feed",       @"Post page", 
                  @"Organization profile",  @"Organization settings",           @"User profile",    @"User settings",
                  @"About page",            @"Give page",                       @"Feedback page", nil];
        _areas = [_areas sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    
    return _areas;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    self.selectedArea = self.areas[indexPath.row];
    NSLog(@"[DEBUG] <FeedbackAreaViewController> Area selected: %@ at %d", self.selectedArea, indexPath.row);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = [self.areas count];
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.areas[indexPath.row];
    
    return cell;
}

@end
