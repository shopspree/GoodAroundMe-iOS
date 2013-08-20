//
//  UserProfileViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/14/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CoreDataFactory.h"
#import "UserCell.h"
#import "OrganizationCell.h"
#import "User+Create.h"
#import "UserSettingsViewController.h"
#import "Organization+Create.h"

#define USER_SECTION_INDEX 0
#define ORGANIZATION_SECTION_INDEX 1

#define SECTION_NAME_USER @""
#define SECTION_NAME_FOLLOWING @"Followed organizations"

@interface UserProfileViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *following;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    User *currentUser = [User currentUser:self.user.managedObjectContext];
    if (self.user != currentUser) {
        self.settingsButton.hidden = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)setEmail:(NSString *)email
{
    _email = email;
    
    [self refresh];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (! _managedObjectContext) {
        _managedObjectContext = [CoreDataFactory getInstance].managedObjectContext;
        
    }
    
    return _managedObjectContext;
}

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [NSArray arrayWithObjects:SECTION_NAME_USER, SECTION_NAME_FOLLOWING, nil];
    }
    
    return _sections;
}

- (NSArray *)following
{
    if (! _following) {
        _following = [NSArray array];
    }
    
    return _following;
}

- (void)refresh
{
    if (self.email) {
        [User userByEmail:self.email inManagedObjectContext:self.managedObjectContext success:^(User *user) {
            self.user = user;
            
            if (self.user) {
                NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Organization"];
                request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
                request.predicate = [NSPredicate predicateWithFormat:@"%@ in followers", self.user];
                
                // Execute the fetch
                NSError *error = nil;
                NSArray *matches = [self.managedObjectContext executeFetchRequest:request error:&error];
                
                // Check what happened in the fetch
                NSLog(@"matches count = %d", [matches count]);
                
                self.following = matches;
            }
            
            [self.tableView reloadData];
        } failure:^(NSString *message) {
            [self fail:@"User Profile" withMessage:message];
        }];
    }
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:USER_SETTINGS]) {
        if ([segue.destinationViewController isKindOfClass:[UserSettingsViewController class]]) {
            UserSettingsViewController *userSettingsVC = (UserSettingsViewController *)segue.destinationViewController;
            userSettingsVC.user = self.user;
        }
    }
}


#pragma mark - Storyboard

- (IBAction)settingsButtonAction:(id)sender
{
    [self performSegueWithIdentifier:USER_SETTINGS sender:self];
}

- (IBAction)followMoreOrganizationButton:(id)sender
{
    [self performSegueWithIdentifier:EXPLORE sender:self];
}

- (IBAction)followButton:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Organization *organization = [self.following objectAtIndex:indexPath.row];
        ([organization.is_followed boolValue]) ? [self unfollow:organization] : [self follow:organization];
    }
}

- (void)follow:(Organization *)organization
{
    [self.user
     follow:organization success:^() {
         [self refresh];
    } failure:^(NSString *message) {
        [self fail:@"Follow" withMessage:message];
    }];
}

- (void)unfollow:(Organization *)organization
{
    [self.user
     unfollow:organization success:^() {
        [self refresh];
    } failure:^(NSString *message) {
        [self fail:@"Follow" withMessage:message];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 0;
    switch (section) {
        case USER_SECTION_INDEX:
            numberOfRowsInSection = 1;
            break;

        case ORGANIZATION_SECTION_INDEX:
            numberOfRowsInSection = [self.following count] + 1;
            break;

        default:
            break;
    };
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UserCellIdentifier = @"UserCell";
    static NSString *OrganizationCellIdentifier = @"OrganizationCell";
    static NSString *AddOrganizationCellIdentifier = @"AddOrganizationCell";
    
    UITableViewCell *cell;
    if (indexPath.section == USER_SECTION_INDEX) {
        cell = [tableView dequeueReusableCellWithIdentifier:UserCellIdentifier forIndexPath:indexPath];
        UserCell *userCell = (UserCell *)cell;
        userCell.user = self.user;
        
    } else if (indexPath.section == ORGANIZATION_SECTION_INDEX) {
        NSInteger lastRow = [self.following count];
        if (indexPath.row < lastRow)  {
            cell = [tableView dequeueReusableCellWithIdentifier:OrganizationCellIdentifier forIndexPath:indexPath];
            OrganizationCell *organizationCell = (OrganizationCell *)cell;
            Organization *organization = [self.following objectAtIndex:indexPath.row];
            organizationCell.organization = organization;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:AddOrganizationCellIdentifier forIndexPath:indexPath];
        }
    } 
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = self.tableView.rowHeight;
    
    if (indexPath.section == USER_SECTION_INDEX) {
        height = 223.0f;
        
    } else if (indexPath.section == ORGANIZATION_SECTION_INDEX) {
        height = 60.0f;
        
    } 
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == USER_SECTION_INDEX) {
        // do nothing
        return;
    } else if (indexPath.section == ORGANIZATION_SECTION_INDEX) {
        NSInteger lastRow = [self.following count] - 1;
        if (indexPath.row == lastRow)  {
            [self performSegueWithIdentifier:EXPLORE sender:self];
        }
    } 
}


@end
