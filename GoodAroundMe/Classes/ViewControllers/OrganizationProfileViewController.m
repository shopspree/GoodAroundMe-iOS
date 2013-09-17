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
#import "PostViewController.h"
#import "Post+Create.h"
#import "User+Create.h"
#import "OrganizationSettingsViewController.h"
#import "FollowersTableViewController.h"
#import "GiveViewController.h"

#define SECTION_ORGANIZATION_PROFILE 0
#define SECTION_ORGANIZATION_POSTS 1

#define ACTION_SHEET_DELETE_POST_TAG 2

@interface OrganizationProfileViewController () 

@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *posts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editNavButton;
@property (strong, nonatomic) Post *selectedPost;

@end

@implementation OrganizationProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followButton.selected = [self.organization.is_followed boolValue];
    
    self.title = self.organization.name;
    
    User *user = [User currentUser:self.managedObjectContext];
    if (user.organization && user.organization.uid == self.organization.uid) {
        self.navigationItem.rightBarButtonItem = self.editNavButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    
    if (organization) {
        NSString *title = ([organization.is_followed boolValue]) ? @"✓Follow" : @"Follow";
        [self.followButton setTitle:title forState:UIControlStateNormal];
    }
}

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [NSArray arrayWithObjects:[NSNumber numberWithInt:SECTION_ORGANIZATION_PROFILE], [NSNumber numberWithInt:SECTION_ORGANIZATION_POSTS], nil];
    }
    return _sections;
}

- (NSArray *)posts
{
    if (! _posts) {
        _posts = [self.organization postsForOrganization:^(NSArray *posts) {
            _posts = posts;
            [self.tableView reloadData];
        } failure:^(NSString *message) {
            [self fail:[NSString stringWithFormat:@"Error loading posts for %@", self.organization.name] withMessage:message];
        }];
    }
    return _posts;
}

- (void)refresh
{
    if (self.organization) {
        [self.organization newsfeedForOrganization:^{
            self.posts = [self.organization.posts allObjects];
        } failure:^(NSString *message) {
            [self fail:[NSString stringWithFormat:@"Error refreshing posts for %@", self.organization.name] withMessage:message];
        }];
    }
    
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:POST_PAGE]) {
        if ([segue.destinationViewController isKindOfClass:[PostViewController class]]) {
            
            Post *post = [self selectPost:sender];
            PostViewController *postVC = (PostViewController *)segue.destinationViewController;
            postVC.post = post;
            
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)sender;
                postVC.keyboardIsShown = (button.tag == NEWSFEED_POST_VIEW_COMMENT_BUTTON);
            }
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_SETTINGS]) {
        if ([segue.destinationViewController isKindOfClass:[OrganizationSettingsViewController class]]) {
            OrganizationSettingsViewController *organizationSettingsVC = (OrganizationSettingsViewController *)segue.destinationViewController;
            organizationSettingsVC.organization = self.organization;
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_FOLLOWERS]) {
        if ([segue.destinationViewController isKindOfClass:[FollowersTableViewController class]]) {
            FollowersTableViewController *followersTableVC = (FollowersTableViewController *)segue.destinationViewController;
            followersTableVC.organization = self.organization;
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_GIVE]) {
        if ([segue.destinationViewController isKindOfClass:[GiveViewController class]]) {
            GiveViewController *giveVC = (GiveViewController *)segue.destinationViewController;
            giveVC.organization = self.organization;
        }
    }
}

- (void)follow:(Organization *)organization
{
    self.followButton.selected = YES;
    User *currentUser = [User currentUser:organization.managedObjectContext];
    [currentUser follow:organization success:^() {
         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
     } failure:^(NSString *message) {
         [self fail:@"Follow" withMessage:message];
     }];
}

- (void)unfollow:(Organization *)organization
{
    self.followButton.selected = NO;
    User *currentUser = [User currentUser:organization.managedObjectContext];
    [currentUser unfollow:organization success:^() {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
     } failure:^(NSString *message) {
         [self fail:@"Follow" withMessage:message];
     }];
    
}

- (Post *)selectPost:(id)sender
{
    Post *post = nil;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil && indexPath.section == SECTION_ORGANIZATION_POSTS)
    {
        post = self.posts[indexPath.row];
    }
    
    NSLog(@"[DEBUG] <NewsfeedTableViewController> Post id= %@, likes_count = %@, likes count = %d", post.uid, post.likes_count, [post.likes count]);
    return post;
}

- (void)selectPostAndSegue:(NSString *)identifier sender:(id)sender
{
    [self selectPost:sender];
    [self performSegueWithIdentifier:identifier sender:sender];
}

- (void)deletePostAfterConfirm
{
    Post *post = self.selectedPost;
    if (post) {
        NSLog(@"[DEBUG] <PostViewController> deleted post is %@", [post description]);
        [post deletePost:^{
            // TO DO add activity indicator
            return;
        } failure:^(NSString *message) {
            [self fail:@"Delete post failed" withMessage:message];
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reportInappropriate
{
    Post *post = self.selectedPost;
    [post inappropriate:^{
        [self info:@"Resport Inappropriate" withMessage:@"Thank you. Our team will review your report and act accordnigly"];
    } failure:^(NSString *message) {
        [self fail:@"Resport Inappropriate" withMessage:message];
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

- (IBAction)followersButtonAction:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_FOLLOWERS sender:self];
}

- (IBAction)giveButtonAction:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_GIVE sender:self];
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
    static NSString *OrganizationProfileCellIdentifier = @"OrganizationProfileCell";
    static NSString *PostCellIdentifier = @"PostCell";
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 700.0;
    
    if (indexPath.section == SECTION_ORGANIZATION_PROFILE) {
        height = MAX(self.tableView.frame.size.height, 400);
    } else if (indexPath.section == SECTION_ORGANIZATION_POSTS) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"NewsfeedPostView" owner:self options:nil] lastObject];
        height = view.frame.size.height;
    }
    
    //Newsfeed *newsfeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //UIView *view = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Newsfeed%@View", newsfeed.type] owner:self options:nil] lastObject];
    //height = view.frame.size.height;
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (indexPath.section == SECTION_ORGANIZATION_POSTS) {
        //[self performSegueWithIdentifier:POST_PAGE sender:indexPath];
    //}
}

#pragma mark - NewsfeedPostViewDelegate

- (void)likePost:(id)sender
{
    Post *post = nil;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil && indexPath.section == SECTION_ORGANIZATION_POSTS)
    {
        post = self.posts[indexPath.row];
        
        if (post) {
            if ([post.liked_by_user boolValue]) {
                NSLog(@"[DEBUG] <NewsfeedTableViewController> Unlike post id = %@ likes_count = %@", post.uid, post.likes_count);
                [post unlike:^{
                    return;
                } failure:^(NSString *message) {
                    [self fail:@"Failed to unlike" withMessage:message];
                }];
                NSLog(@"[DEBUG] <NewsfeedTableViewController> Ater Unlike post id = %@ likes_count = %@", post.uid, post.likes_count);
            } else {
                NSLog(@"[DEBUG] <NewsfeedTableViewController> Like post id = %@ likes_count = %@", post.uid, post.likes_count);
                [post like:^(Like *like) {
                    return;
                } failure:^(NSString *message) {
                    [self fail:@"Failed to like" withMessage:message];
                }];
                NSLog(@"[DEBUG] <NewsfeedTableViewController> After Like post id = %@ likes_count = %@", post.uid, post.likes_count);
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    }
}

- (void)commentOnPost:(id)sender
{
    [self selectPostAndSegue:STORYBOARD_POST sender:sender];
}

- (void)likesOnPost:(id)sender
{
    [self selectPostAndSegue:STORYBOARD_POST sender:sender];
}

- (void)goToPost:(id)sender
{
    [self selectPostAndSegue:STORYBOARD_POST sender:sender];
}

- (void)goToOrganization:(id)sender
{
    return; // already in Organization Profile screen - do nothing
}

- (void)deletePost:(id)sender
{
    self.selectedPost = [self selectPost:sender];
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete"
                                                        otherButtonTitles:@"Report Inappropriate", nil];
    cellActionSheet.tag = ACTION_SHEET_DELETE_POST_TAG;
    [cellActionSheet showInView:self.tableView];
}

- (void)more:(id)sender
{
    [self performSegueWithIdentifier:@"MoreOptions" sender:sender];
}

- (void)give:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_GIVE sender:sender];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_DELETE_POST_TAG) {
        switch (buttonIndex) {
            case 0:
                [self deletePostAfterConfirm];
                break;
                
            case 1:
                [self reportInappropriate];
                break;
                
            default:
                break;
        }
    }
}


@end
