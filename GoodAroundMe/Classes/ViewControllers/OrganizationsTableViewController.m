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
#import "CoreDataFactory.h"
#import "OrganizationProfileViewController.h"
#import "NewOrganizationViewController.h"

@interface OrganizationsTableViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addNavButton;

@end

@implementation OrganizationsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    
    User *user = [User currentUser:self.managedObjectContext];
    if ([user.orgOperator boolValue] && (!user.organization)) {
        self.navigationItem.rightBarButtonItem = self.addNavButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)setCategory:(OrganizationCategory *)category
{
    _category = category;
    self.title = category.name;
    [self setupFetchedResultsController];
    
}

- (User *)user
{
    if (! _user) {
        NSManagedObjectContext *managedObjectContext = [CoreDataFactory getInstance].managedObjectContext;
        _user = [User currentUser:managedObjectContext];
    }
    
    return _user;
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
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[OrganizationProfileViewController class]]) {
            OrganizationProfileViewController *organizationProfileVC = (OrganizationProfileViewController *)segue.destinationViewController;
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            Organization *organization = [self.fetchedResultsController objectAtIndexPath:indexPath];
            organizationProfileVC.organization = organization;
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_NEW]) {
        if ([segue.destinationViewController isKindOfClass:[NewOrganizationViewController class]]) {
            NewOrganizationViewController *newOrganizationVC = segue.destinationViewController;
            newOrganizationVC.category = self.category;
            NSLog(@"[DEBUG] <OrganizationsTableViewController> Segue to %@ with category of %@", segue.identifier, newOrganizationVC.category.name);
        }
    }
}

- (void)segueToOrganizationProfile:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_PROFILE sender:indexPath];
}



- (void)follow:(Organization *)organization
{
    [self.user follow:organization success:^() {
        return;
    } failure:^(NSString *message) {
        [self fail:@"Follow" withMessage:message];
    }];
}

- (void)unfollow:(Organization *)organization
{
    [self.user unfollow:organization success:^() {
        return;
    } failure:^(NSString *message) {
        [self fail:@"Follow" withMessage:message];
    }];
    
}

#pragma mark - Storyboard

- (IBAction)tapOrganizationButtonAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    [self segueToOrganizationProfile:indexPath];
}

- (IBAction)newOrganization:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_NEW sender:self];
}

- (IBAction)followButtonAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Organization *organization = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [organization.is_followed boolValue] ? [self unfollow:organization] : [self follow:organization];
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
    //[self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_PROFILE sender:indexPath];
}

@end
