//
//  AmazonAPI.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/23/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "AmazonAPI.h"
#import "StoryboardConstants.h"

@interface AmazonAPI() <AmazonServiceRequestDelegate>

@property (nonatomic, strong) AmazonS3Client *s3;

@end

@implementation AmazonAPI

- (void)uploadImage:(UIImage *)image forOrganization:(NSString *)organizationName delegate:(id<AmazonServiceRequestDelegate>)delegate
{
    NSString *s3BucketPath = [self bucketForOrganization:organizationName];
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:MY_PICTURE_NAME inBucket:s3BucketPath];
    por.contentType = @"image/jpeg";
    NSData *imageData = UIImagePNGRepresentation(image);
    por.data = imageData;
    por.cannedACL = [S3CannedACL publicRead];
    por.delegate = delegate ? delegate : self;
    //[s3 putObject:por];
    
    if (delegate) {
        
    }
    
    S3TransferManager *transferManager = [S3TransferManager new];
    transferManager.s3 = self.s3;
    [transferManager upload:por];
}

- (NSURL *)getFileURL:(NSString *)fileName forOrganization:(NSString *)organizationName
{
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key     = fileName;
    gpsur.bucket  = [self bucketForOrganization:organizationName];
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

- (NSString *)bucketForOrganization:(NSString *)organizationName
{
    NSString *bucketPath = [NSString stringWithFormat:@"%@/%@", MY_PICTURE_BUCKET, organizationName];
    return bucketPath;
}



#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@", request.requestTag, request.url);
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAmazonUploadCompleted object:request];
}

/** Sent when the request transmitted data.
 *
 * On requests which are uploading non-trivial amounts of data, this method can be used to
 * get progress feedback.
 *
 * @param request                   The AmazonServiceRequest sending the message.
 * @param bytesWritten              The number of bytes written in the latest write.
 * @param totalBytesWritten         The total number of bytes written for this connection.
 * @param totalBytesExpectedToWrite The number of bytes the connection expects to write.
 */
-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    float progress = totalBytesWritten/totalBytesExpectedToWrite;
    NSLog(@"[DEBUG] Request tag:%@ url:%@ %f%%!", request.requestTag, request.url, progress);
}

/** Sent when there was a basic failure with the underlying connection.
 *
 * Receiving this message indicates that the request failed to complete.
 *
 * @param request The AmazonServiceRequest sending the message.
 * @param error   An error object containing details of why the connection failed to load the request successfully.
 */
-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@ Failed!", request.requestTag, request.url);
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationAmazonUploadFailed object:self];
}

@end
