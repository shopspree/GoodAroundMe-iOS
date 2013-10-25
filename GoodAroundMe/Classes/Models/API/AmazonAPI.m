//
//  AmazonAPI.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/23/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AmazonAPI.h"
#import "StoryboardConstants.h"
#import "UIImage+Resize.h"

@interface AmazonAPI() <AmazonServiceRequestDelegate>

@property (nonatomic, strong) AmazonS3Client *s3;

@end

@implementation AmazonAPI

- (void)uploadImage:(UIImage *)image toBucket:(NSString *)bucketName delegate:(id<AmazonServiceRequestDelegate>)delegate
{
    NSString *fullBucketPath = [self fullPathBucket:bucketName];
    NSString *fileName = [self generateFileName];
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:fileName inBucket:fullBucketPath];
    por.contentType = @"image/jpeg";
    
    por.data = [image imageData];
    por.cannedACL = [S3CannedACL publicRead];
    por.delegate = delegate;
    //[self.s3 putObject:por];
    
    S3TransferManager *transferManager = [S3TransferManager new];
    transferManager.s3 = self.s3;
    [transferManager upload:por];
}

- (NSURL *)getFileURL:(NSString *)fileName fromBucket:(NSString *)bucketName
{
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key     = fileName;
    gpsur.bucket  = [self fullPathBucket:bucketName];
    gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
    gpsur.responseHeaderOverrides = override;
    NSURL *url = [self.s3 getPreSignedURL:gpsur];
    //[[UIApplication sharedApplication] openURL:url];
    
    return url;
}

- (AmazonS3Client *)s3
{
    if (! _s3) {
        _s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
    }
    
    return _s3;
}

- (NSString *)fullPathBucket:(NSString *)bucketName
{
    NSString *fullBucketPath = [NSString stringWithFormat:@"%@/%@", MY_PICTURE_BUCKET, bucketName];
    return fullBucketPath;
}

- (NSString *)generateFileName
{
    NSString *uid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *fileName = [NSString stringWithFormat:@"goodaroundme_%@.png", uid];
    return fileName;
}

@end
