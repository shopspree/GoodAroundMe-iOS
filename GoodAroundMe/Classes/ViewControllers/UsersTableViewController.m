//
//  UsersTableViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UsersTableViewController.h"
#import "UserProfileViewController.h"
#import "UserCell.h"

@interface UsersTableViewController ()

@end

@implementation UsersTableViewController

static int RowHeight = 60;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)refresh
{
    [self setupFetchedResultsController];
}


- (void)setupFetchedResultsController
{
   // abstract method
}

- (User *)userForIndexPath:(NSIndexPath *)indexPath
{
    //Like *selectedLike = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //User *user = selectedLike.user;
    return nil; //abstract method
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:STORYBOARD_USER_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]]) {
            UserProfileViewController *userProfileVC = (UserProfileViewController *)segue.destinationViewController;
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            User *user = [self userForIndexPath:indexPath];
            userProfileVC.email = user.email;
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    User *user = [self userForIndexPath:indexPath];
    cell.user = user;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:STORYBOARD_USER_PROFILE sender:indexPath];
}

@end
