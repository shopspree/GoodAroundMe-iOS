//
//  CustomViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/14/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <AWSS3/AWSS3.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewPostCaptionViewController.h"
#import "AmazonAPI.h"
#import "Organization+Create.h"
#import "Post+Create.h"
#import "Picture+Create.h"
#import "StoryboardConstants.h"

@interface NewPostCaptionViewController () <UITextFieldDelegate, AmazonServiceRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation NewPostCaptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.image) {
        self.backgroundImageView.image = self.image;
    }
    self.activityIndicator.hidden = YES;
    
    self.titleTextField.delegate = self;
    self.captionTextField.delegate = self;
}

- (void)uploadtoAmazon
{
    User *currentUser = [User currentUser:self.managedObjectContext];
    NSString *bucketName = currentUser.organization.uid;
    
    AmazonAPI *api = [[AmazonAPI alloc] init];
    [api uploadImage:self.image toBucket:bucketName delegate:self];
}

- (void)newPost:(NSString *)imageURL
{
    NSString *postCaption = self.captionTextField.text;
    NSString *postTitle = self.titleTextField.text;
    NSString *postImageURL = imageURL;
    
    NSDictionary *pictureDictionary = [NSDictionary dictionaryWithObjectsAndKeys:postImageURL, PICTURE_URL, nil];
    NSArray *mediasArray = [NSArray arrayWithObjects:pictureDictionary, nil];
    NSDictionary *postAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:postCaption, POST_CAPTION,
                                              postTitle, POST_TITLE,
                                              mediasArray, POST_MEDIAS_ATTRIBUTES, nil];
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:postAttributesDictionary, POST, nil];
    
    [Post newPost:postDictionary managedObjectContext:self.managedObjectContext success:^(Post *post) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSString *message) {
        [self fail:@"Failed to create new post" withMessage:message];
        self.shareButton.userInteractionEnabled = YES;
    }];
}

#pragma mark - storyboard

- (IBAction)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapAction:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)shareButtonAction:(id)sender
{
    self.shareButton.userInteractionEnabled = NO;
    [self.view endEditing:YES];
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [self uploadtoAmazon];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self shareButtonAction:textField];
    }
    
    return NO; // We do not want UITextField to insert line-breaks.
}

        
#pragma mark - AmazonServiceRequestDelegate
        
    -(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@", request.requestTag, request.url);
    [self newPost:request.url.absoluteString];
    [self.activityIndicator stopAnimating];
}
    
/** Sent when the request transmitted data.
 *
 * On requests which are uploading non-trivial amounts of data, this method can be used to
 * get progress feedback.
 *
 * @param request                   The AmazonServiceRequest sending the message.
 * @param bytesWritten              The number of bytes written in the latest write.
 * @param totalBytesWritten         The total number of bytes written for this connection.
 * @param totalBytesExpectedToWrite The number of bytes the connection expects to write.
 */
    -(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSLog(@"[DEBUG] Request tag:%@ url:%@ %f%%!", request.requestTag, request.url, progress);
}
    
/** Sent when there was a basic failure with the underlying connection.
 *
 * Receiving this message indicates that the request failed to complete.
 *
 * @param request The AmazonServiceRequest sending the message.
 * @param error   An error object containing details of why the connection failed to load the request successfully.
 */
    -(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@ Failed!", request.requestTag, request.url);
    self.shareButton.userInteractionEnabled = YES;
}


@end
