//
//  UITextView+Truncate.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "UITextView+Truncate.h"

@implementation UITextView (Truncate)

static NSString *ellipsis = @"... See More";

- (void)truncateToHeight
{
    CGFloat height = self.frame.size.height;
    
    /*NSMutableString *truncatedText = [self.text mutableCopy];
    
    // Make sure string is longer than requested width
    if (self.contentSize.height > height)
    {
        // Get range for last character in string
        NSRange range = {truncatedText.length - 1, 1};
        
        // Loop, deleting characters until string fits within width
        while (self.contentSize.height > height)
        {
            [truncatedText deleteCharactersInRange:range]; // Delete character at end
            self.text = truncatedText;
            
            range.location--; // Move back another character
            //NSLog(@"[DEBUG] <UITextView+Truncate> Truncated text:\n%@", truncatedText);
        }
        
        // Append ellipsis
        [truncatedText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.text = [NSString stringWithFormat:@"%@ %@", truncatedText, ellipsis];
    }*/
    
    NSAttributedString *formattedText = [self FitTextToHeight:height];
    self.attributedText = formattedText;
}

- (NSAttributedString *)FitTextToHeight:(NSInteger)height
{
    CGSize size = self.contentSize;
    if (size.height < height) {
        return self.attributedText;
    }
    
    NSInteger index = [self maxIndex:0 toFitText:self.text toHeight:height start:0 end:self.text.length];
    NSString *fittedText = self.text.length > index ? [self formatText:self.text toIndex:index] : self.text;
    
    UIFont *textFont = [UIFont fontWithName:@"GillSans-Light" size:14.0f];
    NSDictionary *textAttr = [NSDictionary dictionaryWithObjectsAndKeys: textFont, NSFontAttributeName, nil];
    NSDictionary *seeMoreAttr = [NSDictionary dictionaryWithObjectsAndKeys: textFont, NSFontAttributeName, [UIColor blueColor], NSForegroundColorAttributeName, nil];
    NSRange range = NSMakeRange(fittedText.length - ellipsis.length, ellipsis.length);
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fittedText attributes:textAttr];
    [attributedText setAttributes:seeMoreAttr range:range];
    
    return attributedText;
}

- (NSInteger)maxIndex:(NSInteger)maxIndex toFitText:(NSString *)originalText toHeight:(NSInteger)height start:(NSInteger)start end:(NSInteger)end
{
    if (start > end) {
        return maxIndex;
    }
    
    NSInteger middle = (start + end)/2;
    self.attributedText = [[NSAttributedString alloc] initWithString:[self formatText:originalText toIndex:middle]];
    
    CGSize size = self.contentSize;
    if (size.height > height) {
        return [self maxIndex:maxIndex toFitText:originalText toHeight:height start:start end:(middle-1)];
    } else {
        return [self maxIndex:middle toFitText:originalText toHeight:height start:(middle+1) end:end];
    }
}

- (NSString *)formatText:(NSString *)text toIndex:(NSInteger)index
{
    NSString *formattedText = nil;
    
    if (index < 0 || index > text.length) {
        return formattedText;
    }
    
    NSString *truncatedText = [text substringToIndex:index];
    formattedText = [NSString stringWithFormat:@"%@ %@", truncatedText, ellipsis];
    
    return formattedText;
}


@end
