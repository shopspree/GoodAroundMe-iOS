//
//  CustomViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/14/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewPostCaptionViewController.h"

@interface NewPostCaptionViewController () <UITextViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic) CGRect captionInputTextViewFrameOrigin;
@property (weak, nonatomic) IBOutlet UITextView *captionInputTextView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet UIButton *mentionButton;
@property (weak, nonatomic) IBOutlet UIButton *hashtagButton;

@end

@implementation NewPostCaptionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    // setup captionInputTextView
    self.captionInputTextView.delegate = self;
    self.captionInputTextView.keyboardType = UIKeyboardTypeDefault;
    self.captionInputTextView.returnKeyType = UIReturnKeyDone;
    self.captionInputTextView.alpha = 0.9;
    self.captionInputTextView.textColor = [UIColor whiteColor];
    self.captionInputTextView.backgroundColor = [UIColor blackColor];
    
    
    // hide hashtah & mention buttons
    [self hideButtons:YES];
}

#pragma mark - storyboard


- (IBAction)nextButtonClicked:(id)sender
{
    [self.postDictionary setObject:self.captionInputTextView.text forKey:CONTENT];
    
    [self performSegueWithIdentifier:@"PostCategory" sender:self];
}

- (IBAction)mentionButtonClicked:(id)sender
{
    self.captionInputTextView.text = [self.captionInputTextView.text stringByAppendingString:@"@"];
    [self.captionInputTextView becomeFirstResponder];
}

- (IBAction)hashtagButtonClicked:(id)sender
{
    self.captionInputTextView.text = [self.captionInputTextView.text stringByAppendingString:@"#"];
    [self.captionInputTextView becomeFirstResponder];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PostCategory"]) {
        if ([sender respondsToSelector:@selector(postDictionary)]) {
            NSMutableDictionary *postDictionary = [sender performSelector:@selector(postDictionary)];
            if (postDictionary) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPostDictionary:)]) {
                    [segue.destinationViewController performSelector:@selector(setPostDictionary:) withObject:postDictionary];
                    
                }
            }
        }
    }
}

#pragma mark - keyboard

- (IBAction)keyboardWillShow:(id)sender
{
    const int keyboardHeight = 216.0; // tweak as needed
    
    [self hideButtons:NO];
}

- (IBAction)keyboardWillHide:(id)sender
{
   
    [self hideButtons:YES];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.captionInputTextView resignFirstResponder];
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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    return YES;
}

#pragma mark - private methods

- (void)hideButtons:(BOOL)hide
{
    self.hashtagButton.hidden = hide;
    self.mentionButton.hidden = hide;
}


@end
