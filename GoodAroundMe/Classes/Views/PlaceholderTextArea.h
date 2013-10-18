//
//  PlaceholderTextArea.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/12/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//



@interface PlaceholderTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong) NSString *placeholderText;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIColor *realTextColor;

- (NSString *)actualText;

@end
