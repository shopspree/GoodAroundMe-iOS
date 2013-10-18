//
//  FollowersTableViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/10/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "FollowersTableViewController.h"

@interface FollowersTableViewController ()

@end

@implementation FollowersTableViewController

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    if (organization) {
        [self refresh];
        [organization followersForOrganization:^(NSArray *followers) {
            [self refresh];
        } failure:^(NSString *message) {
            [self fail:@"Retrieving followers list failed" withMessage:message];
        }];
    }
}

- (void)refresh
{
    [super refresh];
    self.title = [NSString stringWithFormat:@"%@ Followers", self.organization.followers_count];
}


- (void)setupFetchedResultsController
{
    if (self.organization.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"self in %@", self.organization.followers];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [self.organization.managedObjectContext executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        NSLog(@"matches count = %d", [matches count]);
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.organization.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (User *)userForIndexPath:(NSIndexPath *)indexPath
{
    User *user = nil;
    if (indexPath) {
        user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    return user;
}

@end
