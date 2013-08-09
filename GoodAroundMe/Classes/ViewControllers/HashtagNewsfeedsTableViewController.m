//
//  HashtagNewsfeedsTableViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "HashtagNewsfeedsTableViewController.h"

@interface HashtagNewsfeedsTableViewController ()

@end

@implementation HashtagNewsfeedsTableViewController

- (void)fetchCoreData:(NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Newsfeed"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"post IN %@", self.hashtag.posts];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
