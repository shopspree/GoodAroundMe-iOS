//
//  CustomViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/14/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewPostCaptionViewController.h"

@interface NewPostCaptionViewController () <UITextViewDelegate>
@property (nonatomic) CGRect captionInputTextViewFrameOrigin;
@property (weak, nonatomic) IBOutlet UITextView *captionInputTextView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;

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
}

#pragma mark - storyboard


- (IBAction)nextButtonClicked:(id)sender
{
    [self.postDictionary setObject:self.captionInputTextView.text forKey:CONTENT];
    
    [self performSegueWithIdentifier:@"PostCategory" sender:self];
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


@end
