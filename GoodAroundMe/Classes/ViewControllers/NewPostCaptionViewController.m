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

@interface NewPostCaptionViewController () <UITextViewDelegate, AmazonServiceRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;


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
}

- (void)uploadtoAmazon
{
    User *currentUser = [User currentUser:self.managedObjectContext];
    NSString *organziationName = currentUser.organization.name;
    
    AmazonAPI *api = [[AmazonAPI alloc] init];
    [api uploadImage:self.image forOrganization:organziationName delegate:nil];
}

- (void)newPost:(NSString *)imageURL
{
    NSString *postCaption = self.captionTextField.text;
    NSString *postTitle = self.titleTextField.text;
    NSString *postImageURL = imageURL;
    
    NSDictionary *postDictionary = [NSDictionary dictionaryWithObjectsAndKeys:postCaption, POST_CAPTION,
                                    postTitle, POST_TITLE,
                                    @[[NSDictionary dictionaryWithObjectsAndKeys:postImageURL, PICTURE_URL , nil]], POST_MEDIAS, nil];
    
    [Post newPost:postDictionary managedObjectContext:self.managedObjectContext success:^(Post *post) {
        // TO DO
    } failure:^(NSString *message) {
        [self fail:" withMessage:<#(NSString *)#>]
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
    [self.view endEditing:YES];
    
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

        
#pragma mark - AmazonServiceRequestDelegate
        
    -(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@", request.requestTag, request.url);
    [self newPost:request.url.absoluteString];
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
    float progress = totalBytesWritten/totalBytesExpectedToWrite;
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

}


@end
