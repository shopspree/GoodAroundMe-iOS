//
//  ExploreViewController.h
//  TempName
//
//  Created by asaf ahi-mordehai on 7/8/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExploreViewController : UIViewController <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
