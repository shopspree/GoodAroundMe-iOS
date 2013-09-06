//
//  LikesTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "LikesTableViewController.h"
#import "LikeCell.h"
#import "CoreDataFactory.h"
#import "Like.h"
#import "User.h"
#import "UserProfileViewController.h"

#define ROW_HEIGHT 60.0

@interface LikesTableViewController ()

@end

@implementation LikesTableViewController

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        [post likes:^(NSArray *likes) {
            [self setupFetchedResultsController];
            self.title = [NSString stringWithFormat:@"%@ Likes", post.likes_count];
        } failure:^(NSString *message) {
            [self fail:@"Retrieving likes list failed" withMessage:message];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)setupFetchedResultsController
{
    if (self.post.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Like"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"post = %@", self.post];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [self.post.managedObjectContext executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        NSLog(@"matches count = %d", [matches count]);
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.post.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:STORYBOARD_USER_PROFILE]) {
        if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]]) {
            UserProfileViewController *userProfileVC = (UserProfileViewController *)segue.destinationViewController;
            Like *like = [self.fetchedResultsController objectAtIndexPath:(NSIndexPath *)sender];
            User *user = like.user;
            userProfileVC.email = user.email;
        }
        
        
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LikeCell" forIndexPath:indexPath];
 
    Like *like = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.like = like;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:STORYBOARD_USER_PROFILE sender:indexPath];
}


@end
