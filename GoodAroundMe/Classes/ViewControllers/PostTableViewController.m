//
//  NewsfeedTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/9/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "PostTableViewController.h"
#import "CommentCell.h"
#import "NewsfeedCell.h"
#import "Newsfeed.h"
#import "Comment.h"
#import "User.h"
#import "UserProfileViewController.h"

@interface PostTableViewController ()
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@implementation PostTableViewController

- (void)setPost:(Post *)post
{
    _post = post;
    
    if (!post.newsfeed) {
        [post newsfeedForPost:^(Newsfeed *newsfeed) {
            [self setup];
        } failure:^(NSString *message) {
            // TO DO
        }];
    } else {
        [self setup];
    }
    
}

- (void)setup
{
    [self.post comments:^(NSArray *comments) {
        [self setupFetchedResultsController];
    } failure:^(NSString *message) {
        [self fail:@"Good Around Me" withMessage:message];
    }];
}

- (void)setupFetchedResultsController
{
    if (self.post.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Comment"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"post = %@", self.post];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.post.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (IBAction)usernameTapped:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint tapLocation = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    if (indexPath) {
        Comment *comment = [self commentForIndexPath:indexPath];
        NSLog(@"User tapped is %@", comment.user.email);
        [self performSegueWithIdentifier:@"UserProfile" sender:comment];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:USER_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]] && [sender isKindOfClass:[Comment class]]) {
            UserProfileViewController *userProfileVC = (UserProfileViewController *)segue.destinationViewController;
            Comment *comment = (Comment *)sender;
            
            userProfileVC.user = comment.user;
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
    NSLog(@"comments count = %d", [self.post.comments count]);
    rows += 1;
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"NewsfeedCell";
        NewsfeedCell *newsfeedCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        newsfeedCell.newsfeed = self.post.newsfeed;
        
        return newsfeedCell;
    } else {
        static NSString *CellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Comment *comment = [self commentForIndexPath:indexPath];
        cell.comment = comment;
        cell.userInteractionEnabled = YES;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped:)];
        [cell.usernameLabel setUserInteractionEnabled:YES];
        [cell.usernameLabel addGestureRecognizer:tap];
        
        return cell;
    }
}

- (Comment *)commentForIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section]];
    return comment;
}

#define GUTTER_VERTICAL 10.0f
#define TIMESTAMP_HEIGHT 21.0f

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 700.0;
    if (indexPath.row == 0) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"NewsfeedPostView" owner:self options:nil] lastObject];
        height = view.frame.size.height;
    } else {
        // Get the comment
        NSIndexPath *commentIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
        Comment *comment = [self.fetchedResultsController objectAtIndexPath:commentIndexPath];
        
        // size the cell according to the comment content
        if (comment) {
            
            CGSize constraint = CGSizeMake(232.0f, 1000.0f);
            // size of name label
            NSString *username = [NSString stringWithFormat:@"%@ %@", comment.user.firstname, comment.user.lastname];
            CGSize usernameSize = [username sizeWithFont:[UIFont fontWithName:@"Gill Sans Light" size:14.0f]
                                       constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            // size of content label
            NSString *content = comment.content;
            CGSize contentSize = [content sizeWithFont:[UIFont fontWithName:@"Gill Sans Light" size:14.0f]
                                     constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            // ---
            // |
            //  username
            // |
            //  content
            // |
            //  timestamp
            // ---
            height = GUTTER_VERTICAL + usernameSize.height + GUTTER_VERTICAL + contentSize.height + GUTTER_VERTICAL + TIMESTAMP_HEIGHT;
            
            height = MAX(height, 90.f);
        }
    }
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        self.selectedIndexPath = indexPath;
        UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete comment"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:@"Delete"
                                                            otherButtonTitles:nil, nil];
        [cellActionSheet showInView:self.tableView];
    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (self.selectedIndexPath) {
                Comment *selectedComment = [self commentForIndexPath:self.selectedIndexPath];
                NSLog(@"[DEBUG] deleted comment is %@", [selectedComment description]);
                [self.post deleteComment:selectedComment success:^{
                    [self.tableView reloadData];
                } failure:^(NSString *message) {
                    [self fail:@"Deletec comment failed" withMessage:message];
                }];
            }
            break;
            
        default:
            break;
    }
}

@end
