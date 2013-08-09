//
//  NewPostCategoryViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/15/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NewPostCategoryViewController.h"
#import "Category+Create.h"
#import "CategoryCell.h"

@interface NewPostCategoryViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) NSArray *categories;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;

@end

@implementation NewPostCategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.categoriesCollectionView.delegate = self;
    self.categoriesCollectionView.dataSource = self;
    self.categoriesCollectionView.backgroundColor = [UIColor clearColor];
    
    // categoryLabel
    self.categoryLabel.backgroundColor = [UIColor purpleColor];
    self.categoryLabel.textColor = [UIColor whiteColor];
}

- (NSArray *)categories
{
    if (!_categories) {
        _categories = [NSArray array];
        [Category categories:^(NSArray *categories) {
            _categories = categories;
            [self.categoriesCollectionView reloadData];
        } failure:^(NSDictionary *errorData) {
            // TO DO
        }];
    }
    
    return  _categories;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PostSubcategory"]) {
        Category *category = [self.postDictionary objectForKey:CATEGORY];
        if (category) {
            if ([segue.destinationViewController respondsToSelector:@selector(setCategory:)]) {
                [segue.destinationViewController performSelector:@selector(setCategory:) withObject:category];
            }
        }
    }
}

#pragma mark - storyboard

- (IBAction)xButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Category *category = [self.categories objectAtIndex:indexPath.item];
    [self.postDictionary setObject:category forKey:CATEGORY];
    [self performSegueWithIdentifier:@"PostSubcategory" sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    CategoryCell *cell = [self.categoriesCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    //customize cell
    Category *category = [self.categories objectAtIndex:indexPath.item];
    cell.categoryLabel.text = category.name;
    
    return cell;
}



@end
