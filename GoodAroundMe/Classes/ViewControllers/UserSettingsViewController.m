//
//  UserSettingsViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/24/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserSettingsViewController.h"
#import "User+Create.h"

#define CHANGE_PASSWORD @"Change password"
#define LOGOUT @"Log out"

@interface UserSettingsViewController ()
@property (nonatomic, strong) NSArray *sections;

@end

@implementation UserSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *about = [NSArray arrayWithObjects:@"About", @"Info", nil];
    NSArray *user = [NSArray arrayWithObjects:CHANGE_PASSWORD, LOGOUT, nil];
    self.sections = [NSArray arrayWithObjects:about, user, nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = [self.sections count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     NSInteger numberOfRows = [[self.sections objectAtIndex:section] count];
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selection = [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([selection isEqualToString:LOGOUT]) {
        [User signOut:^{
            [self performSegueWithIdentifier:@"SignOut" sender:self];
        } failure:^(NSDictionary *errorData) {
            // TO DO
        }];
    } else if ([selection isEqualToString:CHANGE_PASSWORD]) {
        [self performSegueWithIdentifier:@"ChangePassword" sender:self];
    }
}

@end
