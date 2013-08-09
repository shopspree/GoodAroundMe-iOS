//
//  ExploreViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/8/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "ExploreViewController.h"
#import "DiscoverBigCell.h"
#import "DiscoverSmallCell.h"
#import "User+Create.h"
#import "Hashtag+Create.h"
#import "Picture+Create.h"
#import "Post+Create.h"
#import "CoreDataFactory.h"
#import "HashtagNewsfeedsTableViewController.h"
#import "UserProfileViewController.h"
#import "PostViewController.h"

#define SCOPE_PEOPLE @"People"
#define SCOPE_HASHTAGS @"Hashtags"
#define SERVER_SEARCH_PAGE_SIZE 25

@interface ExploreViewController ()
@property (nonatomic, strong) NSArray *scopes;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
     /* arrayWithObjects:@"http://24.media.tumblr.com/151b97a6c23119af628c738209d77a02/tumblr_mlvwm7Fzee1qzygxio1_1280.jpg",
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
                   @"http://24.media.tumblr.com/defe0f7def2995dbf93d909802128006/tumblr_mlf0ogfm7e1qdhfhho1_1280.jpg", nil];*/
    
    self.scopes = [NSArray arrayWithObjects:SCOPE_PEOPLE, SCOPE_HASHTAGS, nil];
    
    // create a mutable array to contain products for the search results table
    self.searchDisplayController.searchBar.scopeButtonTitles = self.scopes;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (! self.managedObjectContext) {
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            self.managedObjectContext = managedObjectContext;
        } get:^(NSManagedObjectContext *managedObjectContext) {
            self.managedObjectContext = managedObjectContext;
        }];
    } else {
        [self retrievePopularPost];
    }
    
    
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    [self retrievePopularPost];
    
}

- (void)retrievePopularPost
{
    if (self.managedObjectContext) {
        [Post popular:self.managedObjectContext success:^(NSArray *postArray) {
            self.images = [NSMutableArray array];
            for (Post *post in postArray) {
                Picture *picture = [post.pictures anyObject];
                if (picture) {
                    [self.images addObject:picture];
                }
            }
            [self.collectionView reloadData];
        } failure:^(NSDictionary *errorData) {
            // TO DO
        }];  
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    
    if ([segue.identifier isEqualToString:@"HashtagNewsfeeds"]) {
        Hashtag *hashtag = (Hashtag *)[self.searchResults objectAtIndex:indexPath.row];
        
        HashtagNewsfeedsTableViewController *hashtagNewsfeedsVC = segue.destinationViewController;
        hashtagNewsfeedsVC.hashtag = hashtag;
    } else if ([segue.identifier isEqualToString:@"UserProfile"]) {
        NSDictionary *userDictionary = (NSDictionary *)[self.searchResults objectAtIndex:indexPath.row];
        NSString *userEmail = userDictionary[PROFILE][PROFILE_EMAIL];
        
        UserProfileViewController *userProfileVC = segue.destinationViewController;
        userProfileVC.email = userEmail;
    } else if ([segue.identifier isEqualToString:@"Newsfeed"]) {
        Picture *picture = [self.images objectAtIndex:indexPath.item];
        
        PostViewController *postVC = segue.destinationViewController;
        postVC.post = picture.post;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number = [self.images count];
    return number;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.item + 1) % 7 == 0) {
        static NSString *CellIdentifier = @"BigCell";
        DiscoverSmallCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        Picture *picture = [self.images objectAtIndex:indexPath.item];
        [cell.image setImageWithURL:[NSURL URLWithString:picture.url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        DiscoverBigCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        Picture *picture = [self.images objectAtIndex:indexPath.item];
        [cell.image setImageWithURL:[NSURL URLWithString:picture.url] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"Newsfeed" sender:indexPath];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// If the requesting table view is the search display controller's table view,
    // return the count of the filtered list, otherwise return the count of the main list/
    //
    NSInteger number = 0;
	if (tableView == self.searchDisplayController.searchResultsTableView) {
        number = [self.searchResults count];
    }
    
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"CellIdentifier";
    
    // dequeue a cell from self's table view
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellID];
    
    NSInteger selectedScopeButtonIndex = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    NSString *scope = [self.scopes objectAtIndex:selectedScopeButtonIndex];
    if ([scope isEqualToString:SCOPE_PEOPLE]) {
        NSDictionary *userDictionary = [self.searchResults objectAtIndex:indexPath.row];
        NSString *userName = userDictionary[PROFILE][PROFILE_FULL_NAME];
        NSString *imageURL = userDictionary[PROFILE][PROFILE_THUMBNAIL_URL];
        
        cell.textLabel.text = userName;
        if (![imageURL isKindOfClass:[NSNull class]])
            [cell.imageView setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        else
            cell.imageView.image = [UIImage imageNamed:@"Default.png"];
        
    } else if ([scope isEqualToString:SCOPE_HASHTAGS]) {
        Hashtag *hashtag = [self.searchResults objectAtIndex:indexPath.row];
        NSString *hashtagName = hashtag.key;
        
        cell.textLabel.text = hashtagName;
    }
    
	return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSInteger selectedScopeButtonIndex = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    
    NSString *scope = [self.scopes objectAtIndex:selectedScopeButtonIndex];
    if ([scope isEqualToString:SCOPE_PEOPLE]) {
        [self performSegueWithIdentifier:@"UserProfile" sender:indexPath];
    } else if ([scope isEqualToString:SCOPE_HASHTAGS]) {
        [self performSegueWithIdentifier:@"HashtagNewsfeeds" sender:indexPath];
    }
    
}


#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSInteger selectedScopeButtonIndex = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    NSString *scope = [self.scopes objectAtIndex:selectedScopeButtonIndex];
    
    [self searchString:searchString searchScope:scope];
    
    // return YES to cause the search result table view to be reloaded
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *searchString = self.searchDisplayController.searchBar.text;
    NSString *scope = [self.scopes objectAtIndex:searchOption];
    
    [self searchString:searchString searchScope:scope];
    
    // return YES to cause the search result table view to be reloaded
    return YES;
}

#pragma mark - Content Filtering

- (void)searchString:(NSString *)searchString searchScope:(NSString *)scope
{
    if ([scope isEqualToString:SCOPE_PEOPLE]) {
        if ((! self.searchResults) || ([searchString length] <= 4) || (([self.searchResults count] % SERVER_SEARCH_PAGE_SIZE) == 0)) {
            [User search:searchString page:1 success:^(NSArray *usersArray) {
                self.searchResults = [usersArray mutableCopy];
                [self.searchDisplayController.searchResultsTableView reloadData];
            } failure:^(NSDictionary *errorData) {
                // TO DO
            }];
        } else {
            [self searchLocal:searchString];
        }
        [self.searchDisplayController.searchResultsTableView reloadData];
    } else if ([scope isEqualToString:SCOPE_HASHTAGS]) {
        [Hashtag search:searchString managedObjectContext:self.managedObjectContext success:^(NSArray *hashtagsArray) {
            self.searchResults = [hashtagsArray mutableCopy];
        } failure:^(NSDictionary *errorData) {
            // TO DO
        }];
    }
    
}

- (void)searchLocal:(NSString *)searchString
{
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF.profile.full_name CONTAINS[cd] %@", [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    self.searchResults = [[self.searchResults filteredArrayUsingPredicate:sPredicate] mutableCopy];
    return;
}



@end

/*
 NSDictionary *asaf = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Asaf AM", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *asaf2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Asaf Achi-Mordechai", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *amir = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Amir Michnowski", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *dror = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Dror Bar Lev", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *yoav = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Yoav Koch", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *jonathan = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Jonathan Messika", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *micha = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Micha Tollman", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *arik = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Arik Paz", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *keves = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Elad Keves Dror", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *ran = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"Ran Cohen", PROFILE_FULL_NAME, nil], PROFILE, nil];
 NSDictionary *david = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:@"ASAD@ASAF.com", PROFILE_EMAIL, @"David Vanden Broek", PROFILE_FULL_NAME, nil], PROFILE, nil];
 
 self.searchResults = [NSArray arrayWithObjects:asaf, asaf2, amir, dror, yoav, jonathan, micha, arik, keves, ran, david, nil];
 [self searchLocal:searchString searchArray:self.searchResults];
 */
