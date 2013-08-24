//
//  NewsfeedTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/28/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "NewsfeedTableViewController.h"
#import "NewsfeedCell.h"
#import "UploadPostCell.h"
#import "Newsfeed+Activity.h"
#import "NewsfeedPostView.h"
#import "CoreDataFactory.h"
#import "Post+Create.h"
#import "User+Create.h"
#import "UIResponder+Helper.h"
#import "NewsfeedPostView.h"
#import "Post+Create.h"
#import "PostViewController.h"
#import "NewPostCaptionViewController.h"

#define ACTION_SHEET_NEW_POST_TAG 1
#define ACTION_SHEET_DELETE_POST_TAG 2

@interface NewsfeedTableViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Post *postToDelete;
@property (nonatomic, strong) NSArray *uploads;

@end

@implementation NewsfeedTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // adding refresh controller
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    self.navigationController.navigationBarHidden = NO;

}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    //_managedObjectContext = managedObjectContext;
    [super setManagedObjectContext:managedObjectContext];
    [self fetchCoreData:managedObjectContext];
    
}

- (void)fetchCoreData:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Newsfeed"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]];
        request.predicate = nil; // all newsfeeds
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.postToDelete = nil;
    
    if (! self.managedObjectContext) {
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            self.managedObjectContext = managedObjectContext;
            [self refresh];
        } get:^(NSManagedObjectContext *managedObjectContext) {
            self.managedObjectContext = managedObjectContext;
            [self refresh];
        }];
    } else {
        [self refresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    
    [Newsfeed synchronizeInContext:self.managedObjectContext success:^{
        [self.refreshControl endRefreshing];
    } failure:^(NSString *message) {
        [self.refreshControl endRefreshing];
        [self fail:@"Newsfeed" withMessage:message];
    }];
}

#pragma mark - Storyboard

- (IBAction)cameraButtonPressed:(id)sender
{
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo options"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"From library", nil];
    cellActionSheet.tag = ACTION_SHEET_NEW_POST_TAG;
    [cellActionSheet showInView:self.tableView];
}

- (IBAction)menuButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:MENU sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:STORYBOARD_NEW_POST_CAPTION]) {
        if ([segue.destinationViewController isKindOfClass:[NewPostCaptionViewController class]]) {
            NewPostCaptionViewController *newPostCaptionVC = (NewPostCaptionViewController *)segue.destinationViewController;
            UIImage *image = (UIImage *)sender;
            newPostCaptionVC.image = image;
        }
    } else if ([segue.identifier isEqualToString:@"LikesTable"]) {
        id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
        Post *post = [objectWithPost performSelector:@selector(post)];
        if (post) {
            if ([segue.destinationViewController respondsToSelector:@selector(setPost:)]) {
                [segue.destinationViewController performSelector:@selector(setPost:) withObject:post];
            }
        }
    } else if ([segue.identifier isEqualToString:@"Post"]) {
        id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
        Post *post = [objectWithPost performSelector:@selector(post)];
        if ([segue.destinationViewController isKindOfClass:[PostViewController class]]) {
            PostViewController *postViewController = (PostViewController *)segue.destinationViewController;
            postViewController.post = post;
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)sender;
                postViewController.keyboardIsShown = (button.tag == NEWSFEED_POST_VIEW_COMMENT_BUTTON);
            }
             
        }
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
        Post *post = [objectWithPost performSelector:@selector(post)];
        
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
    
    // upon return form modal segue there is nothing to do
    return;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Newsfeed *newsfeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NewsfeedCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Newsfeed%@Cell", newsfeed.type] forIndexPath:indexPath];
    cell.newsfeed = newsfeed;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 700.0;
    
    Newsfeed *newsfeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"Newsfeed%@View", newsfeed.type] owner:self options:nil] lastObject];
    height = view.frame.size.height;
    
    return height;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_DELETE_POST_TAG) {
        switch (buttonIndex) {
            case 0:
                if (self.postToDelete) {
                    NSLog(@"[DEBUG] deleted post is %@", [self.postToDelete description]);
                    [self.postToDelete deletePost:^{
                        [self.tableView reloadData];
                    } failure:^(NSString *message) {
                        [self fail:@"Delete post failed" withMessage:message];
                    }];
                }
                break;
                
            case 1:
                if (self.postToDelete) {
                    NSLog(@"[DEBUG] Reported as inappropriate post is %@", [self.postToDelete description]);
                    // TO DO
                }
                
            default:
                break;
        }
    } else if (actionSheet.tag == ACTION_SHEET_NEW_POST_TAG) {
        switch (buttonIndex) {
            case 0:
                [self takePhoto];
                break;
            
            case 1:
                [self choosePhotoFromLibrary];
                break;
                
            default:
                break;
        }
        
        //NSString *imageSource = (buttonIndex == 0) ? Camera : PhotoLibrary;
        //[self performSegueWithIdentifier:STORYBOARD_NEW_POST sender:imageSource];
        
    }
    
}

- (void)takePhoto
{
    [self startImagePickerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypeCamera ];
}

- (void)choosePhotoFromLibrary
{
    [self startImagePickerFromViewController:self usingDelegate:self sourceType:UIImagePickerControllerSourceTypePhotoLibrary ];
}

- (BOOL) startImagePickerFromViewController:(UIViewController*)controller
                              usingDelegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate
                                 sourceType:(UIImagePickerControllerSourceType)sourceType

{
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil)) {
        NSLog(@"[ERROR] Cannot access device camera");
        return NO;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = sourceType;//UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or movie capture, if both are available:
    //cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures, or for trimming movies. To instead show the controls, use YES.
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = delegate;
    
    [controller presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"[DEBUG] Presenting device camera completed");
    }];
    
    return YES;
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *image;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        image = editedImage ? editedImage : originalImage;
        //self.imageView.image = image;
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (image, nil, nil , nil);
    }
    
    // Handle a movie capture
    /*
     if (CFStringCompare ((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
     NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
     
     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
     UISaveVideoAtPathToSavedPhotosAlbum(moviePath, nil, nil, nil);
     }
     }
     */
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:STORYBOARD_NEW_POST_CAPTION sender:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [self performSegueWithIdentifier:@"Post" sender:sender];
}

- (void)likesCountButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"Post" sender:sender];
}

- (void)commentsCountButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"Post" sender:sender];
}

- (void)usernameLabelTapped:(id)sender
{
    [self performSegueWithIdentifier:@"UserProfile" sender:self];
}

- (void)deleteButtonClicked:(id)sender
{
    id objectWithPost = [(UIView *)sender traverseResponderChainForSelector:@selector(post)];
    self.postToDelete = [objectWithPost performSelector:@selector(post)];
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete"
                                                        otherButtonTitles:@"Report Inappropriate", nil];
    cellActionSheet.tag = ACTION_SHEET_DELETE_POST_TAG;
    [cellActionSheet showInView:self.tableView];
}

- (void)moreButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"MoreOptions" sender:sender];
}

@end
