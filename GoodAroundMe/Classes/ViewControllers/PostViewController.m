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


#define ACTION_SHEET_DELETE_POST_TAG 2

@interface PostViewController ()

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UIView *commentInputView;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (nonatomic, strong) PostTableViewController *postTableViewController;

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
    
    [self.postTableViewController.tableView reloadData];
}

- (PostTableViewController *)postTableViewController
{
    if (! _postTableViewController) {
        if (self.post) {
            _postTableViewController = [self.childViewControllers lastObject];
            _postTableViewController.post = self.post;
        }
    }
    
    return _postTableViewController;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.keyboardIsShown) {
        [self.commentInputTextField becomeFirstResponder];
    }
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
        User *user;
        if ([sender isKindOfClass:[CommentCell class]]) {
            user = nil;
            // TO DO
        }
        
        if (user) {
            if ([segue.destinationViewController respondsToSelector:@selector(setEmail:)]) {
                [segue.destinationViewController performSelector:@selector(setEmail:) withObject:user.email];
            }
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_GIVE]) {
        if ([segue.destinationViewController isKindOfClass:[GiveViewController class]]) {
            GiveViewController *giveVC = (GiveViewController *)segue.destinationViewController;
            giveVC.organization = self.post.organization;
        }
        
    }
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
        
        [self.postTableViewController.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)commentOnPost:(id)sender
{
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
    } else {
        return; // do nothing already in comments view
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
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete"
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

- (void)keyboardWillShow:(UITextView *)textView
{
    self.isKeyboardShown = YES;
    [self.postTableViewController.tableView addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:textView up:YES];

}


- (void)keyboardWillHide:(UITextView *)textView
{
    self.isKeyboardShown = NO;
    [self.postTableViewController.tableView removeGestureRecognizer:self.tap]; // remove tap gesture
    
    [self animateTextField:textView up:NO];
}

- (void) animateTextField:(UITextView *)textView up:(BOOL)up
{
    const int movementDistance = 216.0; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    if (up) {
        [UIView animateWithDuration:movementDuration animations:^{
            self.commentInputView.frame = CGRectOffset(self.commentInputView.frame, 0, movement);
        } completion:^(BOOL finished) {
            CGRect postFrame = self.postView.frame;
            self.postView.frame = CGRectMake(postFrame.origin.x,
                                              postFrame.origin.y,
                                              postFrame.size.width,
                                              postFrame.size.height + movement);
            postFrame = self.postView.frame;
        }];
    } else {
        [UIView animateWithDuration:movementDuration animations:^{
            self.commentInputView.frame = CGRectOffset(self.commentInputView.frame, 0, movement);
            CGRect postFrame = self.postView.frame;
            self.postView.frame = CGRectMake(postFrame.origin.x,
                                              postFrame.origin.y,
                                              postFrame.size.width,
                                              postFrame.size.height + movement);
        }];
    }
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_DELETE_POST_TAG) {
        switch (buttonIndex) {
            case 0:
                NSLog(@"[DEBUG] <PostViewController> deleted post is %@", [self.post description]);
                [self deletePost];
                break;
                
            case 1:
                NSLog(@"[DEBUG] <PostViewController> Reported as inappropriate post is %@", [self.post description]);
                
                break;
                
            default:
                break;
        }
    }
}


@end
