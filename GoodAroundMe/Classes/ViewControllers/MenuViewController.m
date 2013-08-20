//
//  MenuViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/13/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"
#import "StoryboardConstants.h"
#import "UserProfileViewController.h"
#import "User+Create.h"

#define NAME @"setting name"
#define SEGUE_IDENTIFIER @"identifier"

@interface MenuViewController ()

@end

@implementation MenuViewController

-(NSArray *)menuItems
{
    if (! _menuItems) {
        _menuItems = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"Feed", NAME,
                                                NEWSFEED, SEGUE_IDENTIFIER, nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Explore", NAME,
                       EXPLORE, SEGUE_IDENTIFIER, nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Profile", NAME,
                       USER_PROFILE, SEGUE_IDENTIFIER, nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"About us", NAME,
                       ABOUT_US, SEGUE_IDENTIFIER, nil],
                      [NSDictionary dictionaryWithObjectsAndKeys:@"Send feedback", NAME,
                       FEEDBACK, SEGUE_IDENTIFIER, nil], nil];
    }
    
    return _menuItems;
}

- (IBAction)menuButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:USER_PROFILE]) {
        UserProfileViewController *userProfileVC = (UserProfileViewController *)segue.destinationViewController;
        
        NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
        userProfileVC.email = email;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = [self.menuItems count];
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *settingDictionary = [self.menuItems objectAtIndex:indexPath.row];
    NSString *settingName = [settingDictionary objectForKey:NAME];
    cell.settingLabel.text = settingName;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *settingDictionary = [self.menuItems objectAtIndex:indexPath.row];
    NSString *identifier = [settingDictionary objectForKey:SEGUE_IDENTIFIER];
    
    if (identifier) {
        [self performSegueWithIdentifier:identifier sender:self];
    }
}

@end
