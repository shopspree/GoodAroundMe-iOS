//
//  NEwPostViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/15/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONTENT @"content"
#define CATEGORY @"category"
#define SUBCATEGORY @"subcategory"

@interface NewPostViewController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *postDictionary;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
