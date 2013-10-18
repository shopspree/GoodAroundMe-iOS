//
//  LikesTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/30/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "LikesTableViewController.h"
#import "Like.h"
#import "UserProfileViewController.h"


@interface LikesTableViewController ()

@end

@implementation LikesTableViewController

- (void)setPost:(Post *)post
{
    _post = post;
    if (post) {
        [self refresh];
        [post likes:^(NSArray *likes) {
            [self refresh];
        } failure:^(NSString *message) {
            [self fail:@"Retrieving likes list failed" withMessage:message];
        }];
    }
}

- (void)refresh
{
    [super refresh];
    self.title = [NSString stringWithFormat:@"%@ Likes", self.post.likes_count];
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

- (User *)userForIndexPath:(NSIndexPath *)indexPath
{
    User *user = nil;
    if (indexPath) {
        Like *like = [self.fetchedResultsController objectAtIndexPath:indexPath];
        user = like.user;
    }
    
    return user;
}


@end
