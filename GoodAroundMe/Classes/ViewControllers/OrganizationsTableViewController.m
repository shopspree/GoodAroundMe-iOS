//
//  OrganizationsTableViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "OrganizationsTableViewController.h"
#import "Organization+Create.h"
#import "OrganizationCell.h"

@interface OrganizationsTableViewController ()

@end

@implementation OrganizationsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setCategory:(Category *)category
{
    _category = category;
    self.title = category.name;
    [self setupFetchedResultsController];
    
}

- (void)setupFetchedResultsController
{
    if (self.category) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Organization"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"category = %@", self.category]; // all Organizations belongs to this category
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.category.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        NSLog(@"self.category.organizations = %d || %d", [self.category.organizations count], [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]);
    } else {
        self.fetchedResultsController = nil;
    }
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    OrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Organization *organization = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.organization = organization;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)followButton:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Organization *organization = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ([organization.is_followed boolValue]) ? [self unfollow:organization] : [self follow:organization];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)follow:(Organization *)organization
{
    [organization follow:^(NSDictionary *reponseDictionary) {
        return;
    } failure:^(NSDictionary *errorData) {
        [self fail:@"Follow" withMessage:errorData[@"errors"]];
    }];
}

- (void)unfollow:(Organization *)organization
{
    [organization unfollow:^(NSDictionary *reponseDictionary) {
        return;
    } failure:^(NSDictionary *errorData) {
        // TO DO
    }];
    
}

@end
