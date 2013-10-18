//
//  CoreDataFactory.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/29/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "CoreDataFactory.h"

#define CORE_DATA_EXT @".data"

@interface CoreDataFactory()

@property (nonatomic, strong) NSString *filename;

@end

@implementation CoreDataFactory

static CoreDataFactory *instance;

+ (CoreDataFactory *)getInstance
{
    if(!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{                 // all threads will block here until the block executes
            instance = [[CoreDataFactory alloc] init]; // this line of code can only ever happen once
        });
    }
    return instance;
}

- (NSString *)filename
{
    if (!_filename) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
        
        NSString *build = infoDictionary[(NSString *)kCFBundleVersionKey];
        NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
        
        _filename = [NSString stringWithFormat:@"%@-%@%@", bundleName, build, CORE_DATA_EXT];//, [[NSDate date] description]];
    }
    
    return _filename;
}

- (void)context:(void (^)(NSManagedObjectContext *managedObjectContext))create get:(void (^)(NSManagedObjectContext *managedObjectContext))get
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url = [url URLByAppendingPathComponent:self.filename];
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    // delete all preceding CoreData files
    [self deleteAllCoreDataFiles:CORE_DATA_EXT];
    
    if (self.managedObjectContext) {
        create(self.managedObjectContext);
        get(self.managedObjectContext);
    } else if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
              if (success) {
                  NSLog(@"[INFO] <CoreDataFactory> Using core data file %@", [url path]);
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

- (void)deleteAllCoreDataFiles:(NSString *)prefix
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths lastObject];
    
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:directory isDirectory:&isDir] && isDir) {
        NSError *error = nil;
        NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:&error];
        
        NSLog(@"[DEBUG] <CoreDataFactory> Found %d files at directory %@ ", [files count], directory);
        for (NSString *file in files) {
            if ([file rangeOfString:prefix].location != NSNotFound) {
                NSDictionary *attrs = [fileManager attributesOfItemAtPath:directory error:&error];
                unsigned long long result = [attrs fileSize];
                //NSLog(@"[DEBUG] Found file at directory %@ of name %@ of size %llu", directory, file, result);
                if([fileManager removeItemAtPath:[directory stringByAppendingPathComponent:file] error:&error]) {
                    NSLog(@"[DEBUG] <CoreDataFactory> Delete file %@ of size %llu", file, result);
                }
            }
        }
        
    }
}

@end
