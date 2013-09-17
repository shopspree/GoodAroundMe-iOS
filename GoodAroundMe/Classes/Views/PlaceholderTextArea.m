//
//  PlaceholderTextArea.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/12/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "PlaceholderTextArea.h"

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
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
    _placeholderText = placeholderText;
    
    if (placeholderText) {
        self.text = placeholderText;
        self.textColor = self.placeholderColor;
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"[DEBUG] <PlaceholderTextView> Placeholder text is: \n%@ \n\nText is: \n%@", self.placeholderText, self.text);
    if ([self.text isEqualToString:self.placeholderText]) {
        self.text = @"";
        self.textColor = self.realTextColor;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.text.length == 0){
        self.textColor = self.placeholderColor;
        self.text = self.placeholderText;
        [self resignFirstResponder];
    }
}

- (NSString *)actualText
{
    if ([self.text isEqualToString:self.placeholderText]) {
        return @"";
    }
    
    return self.text;
}

@end
