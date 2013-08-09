//
//  LikesTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "LikesTableViewController.h"
#import "UserCell.h"
#import "CoreDataFactory.h"
#import "Like.h"

#define ROW_HEIGHT 60.0

@interface LikesTableViewController ()
@property (nonatomic, strong) Like *selectedLike;
@end

@implementation LikesTableViewController

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        [post likes:^(NSArray *likes) {
            [self setupFetchedResultsController];
            [self.tableView reloadData];
            self.title = [NSString stringWithFormat:@"%@ Likes", post.likes_count];
        } failure:^(NSDictionary *errorData) {
            // TO DO
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
    if ([segue.identifier isEqualToString:@"UserProfile"]) {
        User *user = self.selectedLike.user;
        if (user) {
            if ([segue.destinationViewController respondsToSelector:@selector(setEmail:)]) {
                [segue.destinationViewController performSelector:@selector(setEmail:) withObject:user.email];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
 
    Like *like = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.user = like.user;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedLike = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"UserProfile" sender:self];
}


@end
