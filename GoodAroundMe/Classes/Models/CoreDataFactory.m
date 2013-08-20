//
//  CoreDataFactory.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CoreDataFactory.h"

@interface CoreDataFactory()
@property (nonatomic, strong) NSString *filename;
@end

@implementation CoreDataFactory

+ (CoreDataFactory *)getInstance
{
    static CoreDataFactory *instance;
    
    if(!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{                 // all threads will block here until the block executes
            instance = [[CoreDataFactory alloc] init]; // this line of code can only ever happen once
        });
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _filename = [NSString stringWithFormat:@"%@-%@.data", CORE_DATA_FILE, [[NSDate date] description]];
    }
    return self;
}

- (void)context:(void (^)(NSManagedObjectContext *managedObjectContext))create get:(void (^)(NSManagedObjectContext *managedObjectContext))get
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:self.filename];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (self.managedObjectContext) {
        create(self.managedObjectContext);
        get(self.managedObjectContext);
    } else if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  create(self.managedObjectContext);
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
                get(self.managedObjectContext);
            }
        }];
    } else {
        get(self.managedObjectContext);
    }
}

- (void)context:(void (^)(NSManagedObjectContext *managedObjectContext))get
{
    [self context:^(NSManagedObjectContext *managedObjectContext) {
        get(managedObjectContext);
    } get:^(NSManagedObjectContext *managedObjectContext) {
        get(managedObjectContext);
    }];
}

@end
