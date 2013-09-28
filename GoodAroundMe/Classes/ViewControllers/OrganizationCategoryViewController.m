//
//  OrganizationCategoryViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/7/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "OrganizationCategoryViewController.h"
#import "CategoryCell.h"
#import "OrganizationCategory+Create.h"
#import "OrganizationsTableViewController.h"

@interface OrganizationCategoryViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OrganizationCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.categories = [OrganizationCategory categories:self.managedObjectContext success:^(NSArray *categories) {
        self.categories = categories;
    } failure:^(NSString *message) {
        [self fail:@"Categories" withMessage:@"Error loading categories"];
    }];
    
}

- (void)setCategories:(NSArray *)categories
{
    _categories = categories;
    if (categories) {
        [self.categoryCollectionView reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"Organizations"]) {
        if ([segue.destinationViewController isKindOfClass:[OrganizationsTableViewController class]]) {
            OrganizationsTableViewController *organizationTableViewController = (OrganizationsTableViewController *)segue.destinationViewController;
            OrganizationCategory *category = (OrganizationCategory *)sender;
            organizationTableViewController.category = category;
        }
    }
}

#pragma mark - Storyboard

- (IBAction)doneButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        return;
    }];
}


#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfItems = [self.categories count];
    return numberOfItems;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CategoryCell *cell = [self.categoryCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    OrganizationCategory *category = [self.categories objectAtIndex:indexPath.item];
    
    cell.categoryLabel.text = category.name;
    if (category.imageURL && ![category.imageURL isEqualToString:@"(null)"]) {
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:category.imageURL done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image) {
                [cell.categoryImage setImage:image];
            } else {
                [cell.categoryImage setImageWithURL:[NSURL URLWithString:category.imageURL]];
            }
         
        }];
    
    }
    
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrganizationCategory *category = [self.categories objectAtIndex:indexPath.item];
    [self performSegueWithIdentifier:@"Organizations" sender:category];

}


@end
