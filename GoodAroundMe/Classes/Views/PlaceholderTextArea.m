//
//  PlaceholderTextArea.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/12/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "PlaceholderTextArea.h"

@interface PlaceholderTextView ()

@property (nonatomic) BOOL inEditMode;

@end

@implementation PlaceholderTextView

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
        [self initialize];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if (self) {
        self.delegate = self;
        self.realTextColor = [UIColor blackColor];
        self.placeholderColor = [UIColor lightGrayColor];
        self.inEditMode = NO;
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    
    if (placeholderText) {
        self.text = placeholderText;
    }
}

- (void)setText:(NSString *)text
{
    if (!self.inEditMode && (!text || text.length == 0)) {
        text = self.placeholderText;
    }
    
    self.textColor = [text isEqualToString:self.placeholderText] ? self.placeholderColor : self.realTextColor;
    
    [super setText:text];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"[DEBUG] <PlaceholderTextView> textViewShouldBeginEditing \nPlaceholder: \t%@ \n\tText is: \t%@", self.placeholderText, self.text);
    self.inEditMode = YES;
    
    if ([self.text isEqualToString:self.placeholderText]) {
        self.text = @"";
        self.textColor = self.realTextColor;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.inEditMode = NO;
    NSLog(@"[DEBUG] <PlaceholderTextView> textViewDidEndEditing");
    if (self.text.length == 0){
        self.textColor = self.placeholderColor;
        self.text = self.placeholderText;
        [self resignFirstResponder];
    }
}
/*
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"[DEBUG] <PlaceholderTextView> textViewDidChange");
    if (!textView.text || textView.text.length == 0){
        textView.text = self.placeholderText;
    }
    
    self.textColor = [textView.text isEqualToString:self.placeholderText] ? self.placeholderColor : self.realTextColor;
}*/

- (NSString *)actualText
{
    if ([self.text isEqualToString:self.placeholderText]) {
        return @"";
    }
    
    return self.text;
}

@end
