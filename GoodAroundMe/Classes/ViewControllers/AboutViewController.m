//
//  AboutViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/28/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    CGRect frame = _textView.frame;
    frame.size.height = self.textView.contentSize.height;
    self.textView.frame = frame;
    
    self.backgroundView.alpha = 0.3;
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.frame = frame;
    
}

@end
