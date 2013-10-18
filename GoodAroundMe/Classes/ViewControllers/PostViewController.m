//
//  NewsfeedViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/9/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PostViewController.h"
#import "PostTableViewController.h"
#import "UIResponder+Helper.h"
#import "CommentCell.h"
#import "User.h"
#import "OrganizationProfileViewController.h"
#import "LikesTableViewController.h"
#import "GiveViewController.h"
#import "UserProfileViewController.h"


#define ACTION_SHEET_DELETE_POST_TAG 2

@interface PostViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (weak, nonatomic) IBOutlet UIView *commentInputView;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (nonatomic, strong) PostTableViewController *postTableViewController;

@property (nonatomic) CGRect viewFrame;
@property (nonatomic) BOOL isKeyboardShown;

@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.postTableView.delegate = self.postTableViewController;
    self.postTableView.dataSource = self.postTableViewController;
    
    [self.postTableViewController viewDidLoad];
    //[self.postTableViewController.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.postTableViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.postTableViewController viewDidAppear:animated];
    
    if (self.isCommentMode && !self.isKeyboardShown) {
        [self.commentInputTextField becomeFirstResponder];
    }
}

- (void)viewWillLayoutSubviews
{
    if (self.isKeyboardShown) {
        self.view.frame = self.viewFrame;
    }
    
    [super viewWillLayoutSubviews];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:STORYBOARD_LIKES]) {
        if ([segue.destinationViewController isKindOfClass:[LikesTableViewController class]]) {
            LikesTableViewController *likesTVC = (LikesTableViewController *)segue.destinationViewController;
            likesTVC.post = self.post;
        }
        
    } else if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[OrganizationProfileViewController class]]) {
            OrganizationProfileViewController *organizationProfileViewController = (OrganizationProfileViewController *)segue.destinationViewController;
            organizationProfileViewController.organization = self.post.organization;
        }
        
    } else if ([segue.identifier isEqualToString:STORYBOARD_USER_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]] && [sender isKindOfClass:[User class]]) {
            UserProfileViewController *userProfileVC = segue.destinationViewController;
            User *user = (User *)sender;
            userProfileVC.user = user;
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_GIVE]) {
        if ([segue.destinationViewController isKindOfClass:[GiveViewController class]]) {
            GiveViewController *giveVC = (GiveViewController *)segue.destinationViewController;
            giveVC.organization = self.post.organization;
        }
    }
}

#pragma mark - private 

- (PostTableViewController *)postTableViewController
{
    if (! _postTableViewController) {
        if (self.post) {
            _postTableViewController = [[PostTableViewController alloc] init];
            _postTableViewController.post = self.post;
            _postTableViewController.masterController = self;
            _postTableViewController.tableView = self.postTableView;
        }
    }
    
    return _postTableViewController;
}

- (void)deletePost{
    if (self.post) {
        NSLog(@"[DEBUG] <PostViewController> deleted post is %@", [self.post description]);
        [self.post deletePost:^{
            // TO DO add activity indicator
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *message) {
            [self fail:@"Delete post failed" withMessage:message];
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reportInappropriate
{
    [self.post inappropriate:^{
        [self info:@"Resport Inappropriate" withMessage:@"Thank you. Our team will review your report and act accordnigly"];
    } failure:^(NSString *message) {
        [self fail:@"Resport Inappropriate" withMessage:message];
    }];
}

- (void)goToUser:(id)sender
{
    if (self.isKeyboardShown) {
        [self tap:sender];
    } else {
        [self performSegueWithIdentifier:STORYBOARD_USER_PROFILE sender:sender];
    }
}

- (IBAction)unwindFromModal:(UIStoryboardSegue *)segue
{
    //MyModalVC *vc = (MyModalVC *)segue.sourceViewController; // get results out of vc, which I presented
}

#pragma mark - storyboard

- (IBAction)tap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)sendCommentButtonAction:(id)sender
{
    NSString *commentText = self.commentInputTextField.text;
    if (!commentText || commentText.length == 0) {
        return;
    }
    
    [self.commentInputTextField resignFirstResponder];
    self.commentInputTextField.text = nil;
    
    [self.post comment:commentText success:^{
        [self.postTableViewController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                                      withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.postTableViewController setupFetchedResultsController];
    } failure:^(NSString *message) {
        [self fail:@"Comment" withMessage:message];
    }];
    
    [self.postTableViewController setupFetchedResultsController];
}

#pragma mark - NewsfeedPostViewDelegate

- (void)likePost:(id)sender
{
    id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
    Post *post = [objectWithPost performSelector:@selector(post)];
    if (post) {
        if ([post.liked_by_user boolValue]) {
            [post unlike:^{
                return;
            } failure:^(NSString *message) {
                [self fail:@"Failed to unlike" withMessage:message];
            }];
        } else {
            [post like:^(Like *like) {
                return;
            } failure:^(NSString *message) {
                [self fail:@"Failed to like" withMessage:message];
            }];
            
        }
        
        [self.postTableViewController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)commentOnPost:(id)sender
{
    self.isCommentMode = YES;
    [self.commentInputTextField becomeFirstResponder];
}

- (void)likesOnPost:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_LIKES sender:self];
}

- (void)goToPost:(id)sender
{
    if (self.isKeyboardShown) {
        [self tap:sender];
    }
}

- (void)goToOrganization:(id)sender
{
    if (self.isKeyboardShown) {
        [self tap:sender];
    } else {
        [self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_PROFILE sender:self];
    }
}

- (void)deletePost:(id)sender
{
    User *currentUser = [User currentUser:self.managedObjectContext];
    NSString *deleteButtonTitle = self.post.organization == currentUser.organization ? @"Delete" : nil;
    
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:deleteButtonTitle
                                                        otherButtonTitles:@"Report Inappropriate", nil];
    cellActionSheet.tag = ACTION_SHEET_DELETE_POST_TAG;
    [cellActionSheet showInView:self.view];
}

- (void)more:(id)sender
{
    [self performSegueWithIdentifier:@"MoreOptions" sender:self];
}

- (void)give:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_GIVE sender:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self.postTableViewController.tableView addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:notification up:YES];

}


- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.postTableViewController.tableView removeGestureRecognizer:self.tap]; // remove tap gesture
    
    [self animateTextField:notification up:NO];
}

- (void)animateTextField:(NSNotification *)notification up:(BOOL)up
{
    self.isCommentMode = up;
    
    const int keyboardHeight = 216.0f; // tweak as needed
    const float movementDuration = [self keyboardAnimationDurationForNotification:notification]; // tweak as needed
    
    int movement = up ? -1 * keyboardHeight : keyboardHeight;
    
    CGRect frame = self.view.frame;
    self.viewFrame = CGRectMake(frame.origin.x,
                                frame.origin.y,
                                frame.size.width,
                                frame.size.height + movement);
    
    if (up) {
        [UIView animateWithDuration:movementDuration animations:^{
            self.postTableView.frame = self.viewFrame;
            self.commentInputView.frame = CGRectOffset(self.commentInputView.frame, 0, movement);
            
            //[self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
            self.view.frame = self.viewFrame;
            self.isKeyboardShown = up;
        }];
    } else {
        [UIView animateWithDuration:movementDuration animations:^{
            self.commentInputView.frame = CGRectOffset(self.commentInputView.frame, 0, movement);
            self.view.frame = self.viewFrame;
            self.postTableView.frame = self.viewFrame;
            self.isKeyboardShown = up;
        }];
    }
    
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_DELETE_POST_TAG) {
        if (buttonIndex == actionSheet.destructiveButtonIndex) {
            NSLog(@"[DEBUG] <PostViewController> deleted post is %@", [self.post description]);
            [self deletePost];
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            NSLog(@"[DEBUG] <PostViewController> Reported as inappropriate post is %@", [self.post description]);
        }
    }
}


@end
