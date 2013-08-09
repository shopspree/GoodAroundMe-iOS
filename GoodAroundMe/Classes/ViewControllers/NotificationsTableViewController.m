//
//  NotificationsTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/22/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "NotificationCell.h"
#import "PostViewController.h"
#import "PostAPI.h"

#define ROW_HEIGHT 60.0f

@interface NotificationsTableViewController ()
@property (nonatomic, strong) Post *selectedPost;
@end

@implementation NotificationsTableViewController

- (void)setUser:(User *)user
{
    _user = user;
    
    [user notifications:^{
        [self setupFetchedResultsController];
        [self.tableView reloadData];
    } failure:^(NSDictionary *errorData) {
        // TO DO
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)setupFetchedResultsController
{
    if (self.user.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"user = %@", self.user];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [self.user.managedObjectContext executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        NSLog(@"matches count = %d", [matches count]);
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.user.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Post"]) {
        if ([segue.destinationViewController isKindOfClass:[PostViewController class]]) {
            PostViewController *postViewController = (PostViewController *)segue.destinationViewController;
            postViewController.post = self.selectedPost;
            postViewController.keyboardIsShown = NO;
        }
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.notification = notification;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Notification *notification = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [PostAPI post:notification.post_id success:^(NSDictionary *responseDictionary) {
        self.selectedPost = [Post postWithDictionary:responseDictionary[POST] inManagedObjectContext:notification.managedObjectContext];
        [self performSegueWithIdentifier:@"Post" sender:self];
    } failure:^(NSDictionary *errorData) {
        // TO DO
    }];
    
}

@end
