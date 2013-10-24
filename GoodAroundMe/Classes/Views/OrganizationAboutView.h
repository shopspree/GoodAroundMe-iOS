//
//  OrganizationAboutView.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 10/24/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrganizationAboutView : UIView

@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

- (CGFloat)sizeToFitText:(NSString *)text;

@end
