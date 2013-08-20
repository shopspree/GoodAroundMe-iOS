//
//  OrganizationProfileViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "OrganizationProfileViewController.h"
#import "OrganizationProfileCell.h"
#import "NewsfeedCell.h"
#import "PostTableViewController.h"
#import "Post+Create.h"
#import "User+Create.h"

#define SECTION_ORGANIZATION_PROFILE 0
#define SECTION_ORGANIZATION_POSTS 1

@interface OrganizationProfileViewController ()

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;


@end

@implementation OrganizationProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingsButton.hidden = YES;
}

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    
    if (organization) {
        NSString *title = ([organization.is_followed boolValue]) ? @"✓Follow" : @"Follow";
        [self.followButton setTitle:title forState:UIControlStateNormal];
        
        User *currentUser = [User currentUser:organization.managedObjectContext];
        if (currentUser && currentUser.organization) {
            if ([currentUser.organization.uid isEqualToString:organization.uid]) {
                self.settingsButton.hidden = NO;
            }
        }
    }
}

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [NSArray arrayWithObjects:SECTION_ORGANIZATION_PROFILE, SECTION_ORGANIZATION_POSTS, nil];
    }
    return _sections;
}

- (NSArray *)posts
{
    if (! _posts) {
        _posts = [NSArray array];
    }
    
    return _posts;
}

- (void)refresh
{
    if (self.organization) {
        [self.organization newsfeedForOrganization:^{
            self.posts = [self.organization.posts allObjects];
        } failure:^(NSString *message) {
            //[self ]
        }];
    }
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:POST_PAGE]) {
        if ([segue.destinationViewController isKindOfClass:[PostTableViewController class]]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            Post *post = [self.posts objectAtIndex:indexPath.row];
            PostTableViewController *postTVC = (PostTableViewController *)segue.destinationViewController;
            postTVC.post = post;
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_SETTINGS]) {
            
    }
}

- (void)follow:(Organization *)organization
{
    User *currentUser = [User currentUser:organization.managedObjectContext];
    [currentUser
     follow:organization success:^() {
         return;
     } failure:^(NSString *message) {
         [self fail:@"Follow" withMessage:message];
     }];
}

- (void)unfollow:(Organization *)organization
{
    User *currentUser = [User currentUser:organization.managedObjectContext];
    [currentUser
     unfollow:organization success:^() {
         return;
     } failure:^(NSString *message) {
         [self fail:@"Follow" withMessage:message];
     }];
    
}

#pragma mark - Storyboard

- (IBAction)settingsButtonAction:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_SETTINGS sender:self];
}

- (IBAction)followButtonAction:(id)sender
{
    ([self.organization.is_followed boolValue]) ? [self unfollow:self.organization] : [self follow:self.organization];
}

- (IBAction)giveButtonAction:(id)sender
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSectionsInTableView = [self.sections count];
    return numberOfSectionsInTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == SECTION_ORGANIZATION_PROFILE) {
        return 1;
    } else if (section == SECTION_ORGANIZATION_POSTS){
        return [self.posts count];
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *OrganizationProfileCellIdentifier = @"Cell";
    static NSString *PostCellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == SECTION_ORGANIZATION_PROFILE) {
        cell = [tableView dequeueReusableCellWithIdentifier:OrganizationProfileCellIdentifier forIndexPath:indexPath];
        OrganizationProfileCell *organizationProfileCell = (OrganizationProfileCell *)cell;
        organizationProfileCell.organization = self.organization;
        
    } else if (indexPath.section == SECTION_ORGANIZATION_POSTS) {
        cell = [tableView dequeueReusableCellWithIdentifier:PostCellIdentifier forIndexPath:indexPath];
        NewsfeedCell *newsfeedCell = (NewsfeedCell *)cell;
        Post *post = [self.posts objectAtIndex:indexPath.row];
        newsfeedCell.newsfeed = post.newsfeed;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_ORGANIZATION_POSTS) {
        [self performSegueWithIdentifier:POST_PAGE sender:indexPath];
    }
}

@end
