//
//  AmazonViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/22/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <AWSS3/AWSS3.h>
#import "AmazonViewController.h"

@interface AmazonViewController () <AmazonServiceRequestDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *bucketTextField;

@end

@implementation AmazonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:@"http://www.shedim.com/bb/styles/CH/imageset/site_logo.png"] placeholderImage:[UIImage imageNamed:@"Default.png"]];
}


- (IBAction)tap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)uploadToAmazonButtonAction:(id)sender
{
    NSLog(@"Uploading to Amazon started ...");
    
    [self uploadImage:self.imageView.image];
}


#define MY_SECRET_KEY @"Hg1vYx8K/+IcntjgTScefb4ox7TxRETuuQ+YKkF7"
#define MY_ACCESS_KEY_ID @"AKIAIYFCVLE2OKFN4FUQ"
#define MY_PICTURE_BUCKET @"GoodAroundMe/media"
#define MY_PICTURE_NAME @"hapoel_logo.png"


- (IBAction)checkBucketButtonAction:(id)sender
{
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
    
    NSArray *buckets = [s3 listBuckets];
    
    
    NSString *s3Bucket = self.bucketTextField.text;
    NSString *s3BucketPath = [NSString stringWithFormat:@"GoodAroundMe/media/%@", s3Bucket];
    if (! [s3 getBucketLocation:s3BucketPath]) {
        [s3 createBucket:[[S3CreateBucketRequest alloc] initWithName:s3BucketPath]];
        
    }
}
- (void)uploadImage:(UIImage *)image
{
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY];
    
    NSString *s3Bucket = self.bucketTextField.text;
    NSString *s3BucketPath = [NSString stringWithFormat:@"GoodAroundMe/media/%@", s3Bucket];
    
    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:MY_PICTURE_NAME inBucket:s3BucketPath];
    por.contentType = @"image/jpeg";
    NSData *imageData = UIImagePNGRepresentation(image);
    por.data = imageData;
    por.cannedACL = [S3CannedACL publicRead];
    //[s3 putObject:por];
    
    S3TransferManager *transferManager = [S3TransferManager new];
    transferManager.s3 = s3;
    [transferManager upload:por];
    
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    gpsur.key     = MY_PICTURE_NAME;
    gpsur.bucket  = MY_PICTURE_BUCKET;
    gpsur.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];  // Added an hour's worth of seconds to the current time.
    gpsur.responseHeaderOverrides = override;
    NSURL *url = [s3 getPreSignedURL:gpsur];
    [[UIApplication sharedApplication] openURL:url];
    

}

@end
