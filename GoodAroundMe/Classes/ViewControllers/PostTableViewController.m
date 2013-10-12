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
#import "NewsfeedPostView.h"
#import "Newsfeed.h"
#import "Comment.h"
#import "User.h"
#import "UserProfileViewController.h"

@interface PostTableViewController () <CommentCellDelegate>

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation PostTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupFetchedResultsController];
}

- (void)setPost:(Post *)post
{
    _post = post;
    self.managedObjectContext = self.post.managedObjectContext;
    
    if (!post.newsfeed) {
        [post newsfeedForPost:^(Newsfeed *newsfeed) {
            [self setup];
        } failure:^(NSString *message) {
            [self fail:[NSString stringWithFormat:@"Post: %@", post.title] withMessage:message];
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
        [self fail:[NSString stringWithFormat:@"Loading comments for post %@", self.post.title] withMessage:message];
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

#pragma mark - CommentCellDelegate

- (IBAction)commentTappedAction:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    CGPoint tapLocation = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    if (indexPath) {
        Comment *comment = [self commentForIndexPath:indexPath];
        if ([self.masterController respondsToSelector:@selector(goToUser:)]) {
            [self.masterController performSelector:@selector(goToUser:) withObject:comment.user];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [super tableView:tableView numberOfRowsInSection:section];
    rows += 1;
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSString *CellIdentifier = @"NewsfeedPostCell";
        NewsfeedCell *newsfeedCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        newsfeedCell.newsfeed = self.post.newsfeed;
        
        return newsfeedCell;
    } else {
        NSString *CellIdentifier = @"CommentCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        Comment *comment = [self commentForIndexPath:indexPath];
        cell.comment = comment;
        cell.delegate = self;
        
        return cell;
    }
}

- (Comment *)commentForIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section]];
    return comment;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 700.0;
    if (indexPath.row == 0) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"NewsfeedPostView" owner:self options:nil] lastObject];
        height = view.frame.size.height;
        
        if ([view isKindOfClass:[NewsfeedPostView class]]) {
            NewsfeedPostView *newsfeedPostView = (NewsfeedPostView *)view;
            height = [newsfeedPostView sizeToFitText:self.post.caption];
        }
        
    } else {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"CommentView" owner:self options:nil] lastObject];
        height = view.frame.size.height;
        
        if ([view isKindOfClass:[CommentView class]]) {
            CommentView *commentView = (CommentView *)view;
            Comment *comment = [self commentForIndexPath:indexPath];
    
            height = [commentView sizeToFitText:[comment getContentText]];
        }
    }
    
    return height;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        self.selectedIndexPath = indexPath;
        
        User *currentUser = [User currentUser:self.managedObjectContext];
        Comment *selectedComment = [self commentForIndexPath:self.selectedIndexPath];
        
        NSString *destructiveButtonTitle = (self.post.organization == currentUser.organization || [selectedComment.user.email isEqualToString:currentUser.email]) ? @"Delete" : nil;
        UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete comment"
                                                                     delegate:self
                                                            cancelButtonTitle:@"Cancel"
                                                       destructiveButtonTitle:destructiveButtonTitle
                                                            otherButtonTitles:nil, nil];
        if (destructiveButtonTitle) {
            [cellActionSheet showInView:self.tableView];
        }
    }
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex && self.selectedIndexPath) {
        Comment *selectedComment = [self commentForIndexPath:self.selectedIndexPath];
        NSLog(@"[DEBUG] <PostTableiewController> Deleted comment is %@", [selectedComment description]);
        [self.post deleteComment:selectedComment success:^{
            [self.tableView reloadData];
        } failure:^(NSString *message) {
            [self fail:@"Delete comment failed" withMessage:message];
        }];
    }
}

@end
