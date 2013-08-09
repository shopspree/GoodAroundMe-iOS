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
#import "Category+Create.h"

@interface OrganizationCategoryViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OrganizationCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [Category categories:^(NSArray *categories) {
        self.categories = categories;
        [self.categoryCollectionView reloadData];
    } failure:^(NSDictionary *errorData) {
        [self fail:@"Categories" withMessage:@"Error loading categories"];
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
    
    Category *category = [self.categories objectAtIndex:indexPath.item];
    
    cell.categoryLabel.text = category.name;
    [cell.categoryImage setImageWithURL:[NSURL URLWithString:category.imageURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Category *category = [self.categories objectAtIndex:indexPath.item];
    [self performSegueWithIdentifier:@"Organizations" sender:category];

}


@end
