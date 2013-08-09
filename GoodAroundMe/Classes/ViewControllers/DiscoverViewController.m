//
//  DiscoverViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "DiscoverViewController.h"
#import "DiscoverBigCell.h"
#import "DiscoverSmallCell.h"

@interface DiscoverViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *discoverCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTableView;


@property (nonatomic, strong) NSArray *images;

@end

@implementation DiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.discoverCollectionView.delegate = self;
    self.discoverCollectionView.dataSource = self;

    self.searchBar.delegate = self;
    //self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"People", @"Hashtags", nil];
    self.searchBar.showsScopeBar = NO;
    self.searchBar.showsCancelButton = NO;
    
    self.searchResultsTableView.hidden = YES;
    self.searchResultsTableView.delegate = self;
    self.searchResultsTableView.dataSource = self;
    
    self.images = [NSArray arrayWithObjects:@"http://24.media.tumblr.com/151b97a6c23119af628c738209d77a02/tumblr_mlvwm7Fzee1qzygxio1_1280.jpg",
                   @"http://24.media.tumblr.com/dd449c08cb695b01e7fdccb7fb48a0fe/tumblr_mlxvr2nHZc1rpcrx8o1_1280.jpg",
                   @"http://31.media.tumblr.com/f5c6f0a84df61b5e44748b023adbccb4/tumblr_mlc39lj1Rx1qbs2oyo1_r1_500.jpg",
                   @"http://25.media.tumblr.com/5aea221b9eaa7fafa5802736fe38da06/tumblr_mlmqx9xlAj1rvr0m6o1_1280.jpg",
                   @"http://31.media.tumblr.com/d20be028fd89d78a8a28bf4c9944296e/tumblr_mliflgMt3z1qlioplo1_1280.jpg",
                   @"http://25.media.tumblr.com/9e9d3eb4d0bea915c1249383f8039df6/tumblr_mldve4WLBe1qja240o1_1280.jpg",
                   @"http://24.media.tumblr.com/94a4fd5be609cf7a73eb612ebaed7fc7/tumblr_mjpggsFYz11qdwo7go1_1280.jpg",
                   @"http://24.media.tumblr.com/82d3381d95bf7fea487d9e77555dc170/tumblr_mlq42dMvRQ1ro7k8ko1_1280.jpg",
                   @"http://24.media.tumblr.com/dd449c08cb695b01e7fdccb7fb48a0fe/tumblr_mlxvr2nHZc1rpcrx8o1_1280.jpg",
                   @"http://31.media.tumblr.com/f5c6f0a84df61b5e44748b023adbccb4/tumblr_mlc39lj1Rx1qbs2oyo1_r1_500.jpg",
                   @"http://25.media.tumblr.com/5aea221b9eaa7fafa5802736fe38da06/tumblr_mlmqx9xlAj1rvr0m6o1_1280.jpg",
                   @"http://24.media.tumblr.com/1e83e6d30d6744c60bd2b10b1848f521/tumblr_mlqb8rLpOT1s9ba5ro1_1280.jpg",
                   @"http://25.media.tumblr.com/10049ba9ee3d6d26c2acc144a1882f8d/tumblr_mlragbgS8m1rpic79o1_500.jpg",
                   @"http://24.media.tumblr.com/defe0f7def2995dbf93d909802128006/tumblr_mlf0ogfm7e1qdhfhho1_1280.jpg", nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.item + 1) % 7 == 0) {
        static NSString *CellIdentifier = @"BigCell";
        DiscoverSmallCell *cell = [self.discoverCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.image setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:indexPath.item]] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        DiscoverBigCell *cell = [self.discoverCollectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell.image setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:indexPath.item]] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TO DO upon choose a photo form the discovery page
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize returnSize = CGSizeZero;
    
    if ((indexPath.item + 1) % 7 == 0) {
        returnSize = CGSizeMake(300.0, 150.0);
    }else{
        returnSize = CGSizeMake(90.0, 90.0);
    }
    
    return returnSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
	searchBar.showsScopeBar = YES;
	[searchBar sizeToFit];
    
	[searchBar setShowsCancelButton:YES animated:YES];
    
    self.discoverCollectionView.hidden = YES;
    self.searchResultsTableView.hidden = NO;
    self.searchResultsTableView.frame = self.discoverCollectionView.frame;
    
	return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
	//searchBar.showsScopeBar = NO;
	//[searchBar sizeToFit];
    
	[searchBar setShowsCancelButton:NO animated:YES];
    
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.searchBar.text = nil;
    self.discoverCollectionView.hidden = NO;
    self.searchResultsTableView.hidden = YES;
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
    cell.textLabel.text = @"Asaf";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    [self animateTextField:textView up:YES];
}


- (void)keyboardWillHide:(UITextView *)textView
{
    
    [self animateTextField:textView up:NO];
}

- (void) animateTextField:(UITextView *)textView up:(BOOL)up
{
    const int keyboardHeight = 216.0; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    if (up) {
        [UIView animateWithDuration:movementDuration animations:^{
            self.searchBar.frame = CGRectMake(0, 0, 320, 94);
            self.searchResultsTableView.frame = CGRectMake(0, 94, 320, self.searchResultsTableView.frame.size.height + keyboardHeight);
            
            NSLog(@"%@", self.searchBar);
            
        }];
    } else {
        [UIView animateWithDuration:movementDuration animations:^{
            self.searchBar.frame = CGRectMake(0, 0, 320, 44);
            self.searchResultsTableView.frame = CGRectMake(0, 94, 320, self.searchResultsTableView.frame.size.height - keyboardHeight);
            
            NSLog(@"%@", self.searchBar);
            
        }];
    }
    
    
}

- (void)dismissKeyboard
{
    NSLog(@"[DEBUG] Called dismissKeyboard");
}

@end
