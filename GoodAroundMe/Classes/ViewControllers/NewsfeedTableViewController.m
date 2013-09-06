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
#import "OrganizationProfileViewController.h"
#import "UIImage+Resize.h"

#define ACTION_SHEET_NEW_POST_TAG 1
#define ACTION_SHEET_DELETE_POST_TAG 2

@interface NewsfeedTableViewController() <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) Post *selectedPost;
@property (nonatomic, strong) NSArray *uploads;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraBarButton;

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
    
    User *currentUser = [User currentUser:self.managedObjectContext];
    if (!currentUser.organization) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)fetchCoreData:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        User *currentUser = [User currentUser:self.managedObjectContext];
        NSArray *following = [currentUser.following allObjects];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Newsfeed"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"organization IN %@", following]; // all Organizations the user follows
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.selectedPost = nil;
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refresh
{
    [self.refreshControl beginRefreshing];
    [self fetchCoreData:self.managedObjectContext];
    
    [Newsfeed synchronizeInContext:self.managedObjectContext success:^{
        [self.refreshControl endRefreshing];
        //[self.tableView reloadData];
        [self fetchCoreData:self.managedObjectContext];
    } failure:^(NSString *message) {
        [self.refreshControl endRefreshing];
        [self fail:@"Newsfeed" withMessage:message];
    }];
}

- (Post *)selectPost:(id)sender
{
    Post *post = nil;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Newsfeed *newsfeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
        self.selectedPost = newsfeed.post;
        post = newsfeed.post;
    }
    NSLog(@"[DEBUG] <NewsfeedTableViewController> Post id= %@, likes_count = %@, likes count = %d", self.selectedPost.uid, self.selectedPost.likes_count, [self.selectedPost.likes count]);
    return post;
}

- (void)selectPostAndSegue:(NSString *)identifier sender:(id)sender
{
    [self selectPost:sender];
    [self performSegueWithIdentifier:identifier sender:sender];
}

#pragma mark - Storyboard

- (IBAction)cameraButtonPressed:(id)sender
{
    UIActionSheet *cellActionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo options"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Take photo", @"From library", nil];
    cellActionSheet.tag = ACTION_SHEET_NEW_POST_TAG;
    [cellActionSheet showInView:self.tableView];
}

- (IBAction)menuButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:STORYBOARD_MENU sender:sender];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:STORYBOARD_NEW_POST_CAPTION]) {
        if ([segue.destinationViewController isKindOfClass:[NewPostCaptionViewController class]]) {
            NewPostCaptionViewController *newPostCaptionVC = (NewPostCaptionViewController *)segue.destinationViewController;
            UIImage *image = (UIImage *)sender;
            newPostCaptionVC.image = image;
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_POST]) {
        if ([segue.destinationViewController isKindOfClass:[PostViewController class]]) {
            PostViewController *postViewController = (PostViewController *)segue.destinationViewController;
            postViewController.post = self.selectedPost;
    
            if ([sender isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)sender;
                postViewController.keyboardIsShown = (button.tag == NEWSFEED_POST_VIEW_COMMENT_BUTTON);
            }       
        }
    } else if ([segue.identifier isEqualToString:STORYBOARD_ORGANIZATION_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[OrganizationProfileViewController class]]) {
            OrganizationProfileViewController *organizationProfileVC = (OrganizationProfileViewController *)segue.destinationViewController;
            Organization *organization = (Organization *)sender;
            organizationProfileVC.organization = organization;
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self selectPostAndSegue:STORYBOARD_POST sender:tableView];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == ACTION_SHEET_DELETE_POST_TAG) {
        switch (buttonIndex) {
            case 0:
                if (self.selectedPost) {
                    NSLog(@"[DEBUG] <NewsfeedTableViewController> deleted post is %@", [self.selectedPost description]);
                    [self.selectedPost deletePost:^{
                        //[self.tableView reloadData];
                    } failure:^(NSString *message) {
                        [self fail:@"Delete post failed" withMessage:message];
                    }];
                }
                break;
                
            case 1:
                if (self.selectedPost) {
                    NSLog(@"[DEBUG] <NewsfeedTableViewController> Reported as inappropriate post is %@", [self.selectedPost description]);
                    [self.selectedPost inappropriate:^{
                        [self info:@"Resport Inappropriate" withMessage:@"Thank you. Our team will review your report and act accordnigly"];
                    } failure:^(NSString *message) {
                        [self fail:@"Resport Inappropriate" withMessage:message];
                    }];
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
        NSLog(@"[ERROR] <NewsfeedTableViewController> Cannot access device camera");
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
        NSLog(@"[DEBUG] <NewsfeedTableViewController> Presenting device camera completed");
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
        
        //image = [self imageWithImage:image scaledToSize:CGSizeMake(320, 269)];
        NewsfeedPostView *view = [[[NSBundle mainBundle] loadNibNamed:@"NewsfeedPostView" owner:self options:nil] lastObject];
        image = [image scaleToSize:CGSizeMake(view.pictureImage.frame.size.width, view.pictureImage.frame.size.height)];
        
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
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:STORYBOARD_NEW_POST_CAPTION sender:image];
    }];
    
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NewsfeedPostViewDelegate

- (void)likePost:(id)sender
{
    Post *post = nil;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        Newsfeed *newsfeed = [self.fetchedResultsController objectAtIndexPath:indexPath];
        post = newsfeed.post;
        
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
    Post *post = [self selectPost:sender];
    [self performSegueWithIdentifier:STORYBOARD_ORGANIZATION_PROFILE sender:post.organization];
}

- (void)deletePost:(id)sender
{
    [self selectPost:sender];
    
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

@end
