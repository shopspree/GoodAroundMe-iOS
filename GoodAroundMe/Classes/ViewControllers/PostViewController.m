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

@property (nonatomic, strong) PostTableViewController *tableViewController;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *commentInputView;
@property (weak, nonatomic) IBOutlet UITextView *commentInputTextView;
@property (weak, nonatomic) IBOutlet UIButton *commentInputPostButton;


@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    // set up the view table
    self.tableViewController = [[PostTableViewController alloc] init];
    self.tableViewController.tableView = self.tableView;
    self.tableViewController.post = self.post;
    self.tableViewController.masterController = self;
    
    
    // hide keyboard gestures
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    // commentInputTextView like UITextField
    self.commentInputTextView.layer.cornerRadius = 5;
    self.commentInputTextView.clipsToBounds = YES;
    [self.commentInputTextView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.commentInputTextView.layer setBorderWidth:2.0];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.keyboardIsShown) {
        [self.commentInputTextView becomeFirstResponder];
        //[self keyboardWillShow:self.commentTextView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"LikesTable"]) {
        if ([sender respondsToSelector:@selector(post)]) {
            Post *post = [sender performSelector:@selector(post)];
            if (post) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPost:)]) {
                    [segue.destinationViewController performSelector:@selector(setPost:) withObject:post];
                    
                }
            }
        }
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        User *user = self.post.user;
        
        if ([sender isKindOfClass:[CommentCell class]]) {
            CommentCell *cell = (CommentCell *)sender;
            Comment *comment = cell.comment;
            user = comment.user;
        }
        
        if (user) {
            if ([segue.destinationViewController respondsToSelector:@selector(setEmail:)]) {
                [segue.destinationViewController performSelector:@selector(setEmail:) withObject:user.email];
            }
        }
    } else if ([segue.identifier isEqualToString:@"MoreOptions"]) {
        id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
        Post *post = [objectWithPost performSelector:@selector(post)];
        if (post) {
            if ([segue.destinationViewController respondsToSelector:@selector(setPost:)]) {
                [segue.destinationViewController performSelector:@selector(setPost:) withObject:post];
            }
        }
    }
}

- (IBAction)unwindFromModal:(UIStoryboardSegue *)segue
{
    //MyModalVC *vc = (MyModalVC *)segue.sourceViewController; // get results out of vc, which I presented
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.tableViewController tableView:tableView numberOfRowsInSection:section];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableViewController tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self.tableViewController tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViewController tableView:tableView didSelectRowAtIndexPath:indexPath];
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
            } failure:^(NSDictionary *errorData) {
                // TODO: display error message
                return;
            }];
        } else {
            [post like:^(Like *like) {
                return;
            } failure:^(NSDictionary *errorData) {
                // TODO: display error message
                return;
            }];
            
        }
    }
}

- (void)commentButtonClicked:(id)sender
{
    [self.commentInputTextView becomeFirstResponder];
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
            [self.tableView reloadData];
        } failure:^(NSDictionary *errorData) {
            // TODO: notify if delete fails
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
    [self.tableView addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:textView up:YES];
    //WithtextView:self.commentInputTextView  containingFrame:self.tableView.frame

}


- (void)keyboardWillHide:(UITextView *)textView
{
    [self.tableView removeGestureRecognizer:self.tap]; // remove tap gesture
    
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
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                              self.tableView.frame.origin.y,
                                              self.tableView.frame.size.width,
                                              self.tableView.frame.size.height + movement);
        }];
    } else {
        [UIView animateWithDuration:movementDuration animations:^{
            self.commentInputView.frame = CGRectOffset(self.commentInputView.frame, 0, movement);
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x,
                                              self.tableView.frame.origin.y,
                                              self.tableView.frame.size.width,
                                              self.tableView.frame.size.height + movement);
        }];
    }
}

- (void)dismissKeyboard
{
    NSLog(@"[DEBUG] Called dismissKeyboard");
    [self.commentInputTextView resignFirstResponder];
}

- (IBAction)commentInputPostButtonClicked:(id)sender
{
    NSString *content = self.commentInputTextView.text;
    [self.post comment:content success:^(Comment *comment) {
        // is required to update data in table ?? [self.tableViewController.tableView reloadData];
        [self.commentInputTextView resignFirstResponder];
        self.commentInputTextView.text = nil; // TODO: capton placeholder
    } failure:^(NSDictionary *errorData) {
        // TODO: notify user on error
    }];
    
    return;
}


@end
