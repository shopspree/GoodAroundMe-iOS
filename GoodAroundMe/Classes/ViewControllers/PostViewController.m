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

@interface PostViewController ()

@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UIView *commentInputView;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCommentButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (nonatomic, strong) PostTableViewController *postTableViewController;

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.keyboardIsShown) {
        [self.commentInputTextField becomeFirstResponder];
    }
}

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        self.postTableViewController = self.childViewControllers.lastObject;
        self.postTableViewController.post = post;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:STORYBOARD_LIKES]) {
        if ([sender respondsToSelector:@selector(post)]) {
            Post *post = [sender performSelector:@selector(post)];
            if (post) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPost:)]) {
                    [segue.destinationViewController performSelector:@selector(setPost:) withObject:post];
                    
                }
            }
        }
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        User *user;
        if ([sender isKindOfClass:[CommentCell class]]) {
            user = nil;
        }
        
        if (user) {
            if ([segue.destinationViewController respondsToSelector:@selector(setEmail:)]) {
                [segue.destinationViewController performSelector:@selector(setEmail:) withObject:user.email];
            }
        }
    }
}

- (IBAction)unwindFromModal:(UIStoryboardSegue *)segue
{
    //MyModalVC *vc = (MyModalVC *)segue.sourceViewController; // get results out of vc, which I presented
}

#pragma mark - NewsfeedPostViewDelegate

- (void)likeButtonClicked:(id)sender
{
    id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
    Post *post = [objectWithPost performSelector:@selector(post)];
    if (post) {
        if (post.liked_by_user) {
            [post unlike:^{
                return;
            } failure:^(NSString *message) {
                [self fail:@"Failed to unlike" withMessage:message];
                return;
            }];
        } else {
            [post like:^(Like *like) {
                return;
            } failure:^(NSString *message) {
                [self fail:@"Failed to like" withMessage:message];
                return;
            }];
            
        }
    }
}

- (void)commentButtonClicked:(id)sender
{
    [self.commentInputTextField becomeFirstResponder];
}

- (void)likesCountButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"LikesTable" sender:self];
}

- (void)commentsCountButtonClicked:(id)sender
{
    // do nothing already in comments view
    return;
}

- (void)usernameLabelTapped:(id)sender
{
    [self performSegueWithIdentifier:@"UserProfile" sender:self];
}

- (void)deleteButtonClicked:(id)sender
{
    if (self.post) {
        NSLog(@"[DEBUG] deleted post is %@", [self.post description]);
        [self.post deletePost:^{
            [self.postTableViewController.tableView reloadData];
        } failure:^(NSString *message) {
            [self fail:@"Delete post failed" withMessage:message];
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moreButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MoreOptions" sender:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    [self.postTableViewController.tableView addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:textView up:YES];
    //WithtextView:self.commentInputTextView  containingFrame:self.tableView.frame

}


- (void)keyboardWillHide:(UITextView *)textView
{
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

- (IBAction)commentInputPostButtonClicked:(id)sender
{
    NSString *content = self.commentInputTextField.text;
    [self.post comment:content success:^(Comment *comment) {
        [self.postTableViewController.tableView reloadData];
        [self.commentInputTextField resignFirstResponder];
        self.commentInputTextField.text = nil; // TODO: capton placeholder
    } failure:^(NSString *message) {
        [self fail:@"Failed to comment" withMessage:message];
    }];
    
    return;
}


@end
