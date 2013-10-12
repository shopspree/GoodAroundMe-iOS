//
//  FeedbackViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/8/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "FeedbackViewController.h"
#import "FeedbackAreaViewController.h"
#import "PlaceholderTextArea.h"
#import "FeedbackAPI.h"
#import "SettingsViewController.h"

@interface FeedbackViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, AmazonServiceRequestDelegate>

@property (strong, nonatomic) IBOutlet PlaceholderTextView *problemReportTextView;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *addScreenshot;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (strong, nonatomic) SettingsViewController *settingsController;
@property (strong, nonatomic) NSString *problemScreenshotURL;

@end

@implementation FeedbackViewController

static NSString *SelectArea = @"Select problem area";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.areaLabel.text = SelectArea;
    self.problemReportTextView.placeholderText = @"Let us know what is broken ...";
    self.addScreenshot.layer.borderWidth = 1.0f;
    self.addScreenshot.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.settingsController = [[SettingsViewController alloc] initWithController:self];
    self.settingsController.imagePickerDelegate = self;
    self.settingsController.amazonDelegate = self;
}

- (void)report
{
    [self startActivityIndicationInNavigationBar];
    
    NSString *area = [self.areaLabel.text isEqualToString:SelectArea] ? nil : self.areaLabel.text;
    
    [FeedbackAPI reportProblem:area
                       content:self.problemReportTextView.actualText
                 screenshotURL:self.problemScreenshotURL
                       success:^(NSDictionary *responseDictionary) {
        [self stopActivityIndicationInNavigationBar];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSString *message) {
        [self stopActivityIndicationInNavigationBar];
        [self fail:@"Report problem failed" withMessage:message];
    }];
}

#pragma mark - Storyboard

- (IBAction)unwindFromSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"[DEBUG] <FeedbackViewController> unwindFromSegue: %@", [[segue.sourceViewController class] description]);
    if ([segue.sourceViewController isKindOfClass:[FeedbackAreaViewController class]]) {
        FeedbackAreaViewController *feedbackAreaVC = (FeedbackAreaViewController *) segue.sourceViewController;
        self.areaLabel.text = feedbackAreaVC.selectedArea;
    }
    
    return;
}

- (IBAction)selectArea:(UIStoryboardSegue *)segue
{
    NSLog(@"[DEBUG] <FeedbackViewController> unwindFromSegue: %@", [[segue.sourceViewController class] description]);
    if ([segue.sourceViewController isKindOfClass:[FeedbackAreaViewController class]]) {
        FeedbackAreaViewController *feedbackAreaVC = (FeedbackAreaViewController *) segue.sourceViewController;
        self.areaLabel.text = feedbackAreaVC.selectedArea;
    }
}

- (IBAction)doneButtonAction:(id)sender
{
    if (self.addScreenshot.imageView.image) {
        [self.settingsController uploadtoAmazon:self.addScreenshot.imageView.image bucket:@"problems"];
    } else {
        [self report];
    }
    
}

- (IBAction)tap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)addScreenshot:(id)sender
{
    [self.settingsController choosePhotoFromLibrary];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self performSegueWithIdentifier:STORYBOARD_FEEDBACK_AREAS sender:self];
    }
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    [self.tableView addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:textView up:YES];
    
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
    
    [UIView animateWithDuration:movementDuration animations:^{
        CGRect frame = self.tableView.frame;
        self.tableView.frame = CGRectMake(frame.origin.x,
                                         frame.origin.y,
                                         frame.size.width,
                                         frame.size.height + movement);
    }];
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
        
        // Save the new image (original or edited) to the Camera Roll
        if (editedImage != originalImage) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil , nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.addScreenshot setImage:image forState:UIControlStateNormal];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"[DEBUG] <FeedbackViewController> Request tag:%@ url:%@", request.requestTag, request.url);
    self.problemScreenshotURL = request.url.absoluteString;
    [self report];
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSLog(@"[DEBUG] <FeedbackViewController> Request tag:%@ url:%@ %f%%!", request.requestTag, request.url, progress * 100);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"[DEBUG] <FeedbackViewController> Request tag:%@ url:%@ Failed!", request.requestTag, request.url);
    [super stopActivityIndicationInNavigationBar];
}

@end
