//
//  MenuViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/13/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "NotificationItemCell.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSArray *)menuItems
{
    return @[@"My feed", @"My profile", @"Notifications", @"Discover",
             @"Coworkers", @"Feedback",@"Groups", @"Help"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCell *cell = nil;
    
    NSString *item = [self.menuItems objectAtIndex:indexPath.item];
    if ([item isEqualToString:@"Notifications"]) {
        NSString *cellIdentifier = @"NotificationItemCell";
        NotificationItemCell *notificationCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        notificationCell.notificationCount = 22; // TO DO: connect with notification API for user
        cell = notificationCell;
        
    } else {
        NSString *cellIdentifier = @"MenuItemCell";
        cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
    cell.itemName.text = item;
    
    return cell;
}

- (IBAction)menuItemTapped:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        NSString *identifier = [self.menuItems objectAtIndex:indexPath.item];
        [self performSegueWithIdentifier:identifier sender:self];
    }
}

@end
