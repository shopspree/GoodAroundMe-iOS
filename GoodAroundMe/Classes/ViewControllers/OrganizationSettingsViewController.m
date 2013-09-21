//
//  OrganizationSettingsViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/6/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrganizationSettingsViewController.h"
#import "UIImage+Resize.h"
#import "PlaceholderTextArea.h"

@interface OrganizationSettingsViewController () <UITextViewDelegate>

@property (nonatomic) BOOL isKeyboardShown;
@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, strong) NSArray *categories;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *organizationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *aboutTextView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveNavButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (strong, nonatomic) IBOutlet UIPickerView *categoriesPicker;
@property (strong, nonatomic) IBOutlet UINavigationItem *customNavigationItem;


@end

@implementation OrganizationSettingsViewController

static NSInteger LogoImageTag = 100;
static NSInteger CategoryLabelTag = 101;
static NSString *AboutPlaceHolder = @"About ...";
static NSInteger pickerSize = 216;


- (void)viewDidLoad
{
    [super viewDidLoad];
    /* */
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.scrollView.contentSize = self.view.frame.size;
    
    self.categoriesPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, 320, pickerSize)];
    self.categoriesPicker.dataSource = self;
    self.categoriesPicker.delegate = self;
    self.categoriesPicker.showsSelectionIndicator = YES;
    [self.view addSubview:self.categoriesPicker];
    
    self.aboutTextView.placeholderText = AboutPlaceHolder;
    
    self.logoImageView.tag = LogoImageTag;
    self.logoImageView.layer.borderWidth = 1.0f;
    self.logoImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    //self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *tapOnCategory = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnCategory:)];
    tapOnCategory.numberOfTouchesRequired = 1;
    [self.categoryLabel addGestureRecognizer:tapOnCategory];
    self.categoryLabel.tag = CategoryLabelTag;
    self.categoryLabel.userInteractionEnabled = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    NSLog(@"[DEBUG] <%@> Settings for organziation uid %@ \nname %@ location %@ category %@ about %@ \nupdates count %@ \nfollowers count %@", [self currentViewController], self.organization.uid, self.organization.name, self.organization.location, self.organization.category.name, self.organization.about, self.organization.posts_count, self.organization.followers_count);
    
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)refresh
{
    [self.logoImageView setImageWithURL:[NSURL URLWithString:self.organization.image_thumbnail_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        image = [image scaleToSize:CGSizeMake(self.logoImageView.frame.size.width, self.logoImageView.frame.size.height)];
    }];
    
    self.organizationNameTextField.text = self.organization.name;
    
    self.locationTextField.text = self.organization.location;
    
    if (self.category) {
        self.categoryLabel.text = self.category.name;
    }
    
    self.aboutTextView.text = self.organization.about;
}

- (void)setOrganization:(Organization *)organization
{
    _organization = organization;
    if (organization.category) {
        self.category = organization.category;
    }
}

- (void)setCategory:(OrganizationCategory *)category
{
    _category = category;
    self.categoryLabel.text = category.name;
    NSLog(@"[DEBUG] <OrganizationSettingsViewController> Set category with name %@", category.name);
}

- (SettingsViewController *)settingsController
{
    if (!_settingsController) {
        _settingsController = [[SettingsViewController alloc] initWithController:self];
        _settingsController.imagePickerDelegate = self;
        _settingsController.amazonDelegate = self;
    }
    return _settingsController;
}

- (NSArray *)categories
{
    if (!_categories) {
        _categories = [OrganizationCategory categories:self.managedObjectContext];
    }
    return _categories;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
}

- (void)startActivityIndicationInNavigationBar
{
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    self.customNavigationItem.rightBarButtonItem = barButton;
    [self.activityIndicator startAnimating];
}

- (void)stopActivityIndicationInNavigationBar
{
    [self.activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = self.saveNavButton;
}

- (void)changePicture:(UIImage *)image
{
    self.logoImage = image;
    [self.logoImageView setImage:image];
}

- (void)updateOrganization
{
    [self setOrganizationWithData];
    
    [self.organization update:^{
        [self completion];
    } failure:^(NSString *message) {
        [self fail:@"Update Organization" withMessage:message];
    }];
}

- (void)createOrganization
{
    self.organization = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:self.managedObjectContext];
    [self setOrganizationWithData];
    
    [self.organization create:^{
        if (self.logoImage) {
            [self.settingsController uploadtoAmazon:self.logoImage bucket:self.organization.uid];
        } else {
            [self completion];
        }
    } failure:^(NSString *message) {
        [self fail:@"Create Organization" withMessage:message];
    }];
    
}

- (void)setOrganizationWithData
{
    if (self.organization) {
        self.organization.name = self.organizationNameTextField.text;
        self.organization.location = self.locationTextField.text;
        self.organization.about = self.aboutTextView.actualText;
        self.organization.category = self.category;
    }
}

- (void)saveOrganization
{
    [self updateOrganization];
}

- (void)completion
{
    [self stopActivityIndicationInNavigationBar];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - public

- (NSString *)organizationName
{
    return self.organizationNameTextField.text;
}

- (NSString *)organizationLocation
{
    return self.locationTextField.text;
}

- (NSString *)organizationAbout
{
    return [self.aboutTextView.text isEqualToString:AboutPlaceHolder]? nil : self.aboutTextView.text;
}

- (void)uploadImageToAmazon
{
    if (self.logoImage) {
        [self.settingsController uploadtoAmazon:self.logoImage bucket:self.organization.uid];
    } else {
        [self completion];
    }
}

#pragma mark - Storyboard

- (IBAction)changeLogoAction:(id)sender
{
    [self.settingsController changeImage:self.view];
}

- (IBAction)saveAction:(id)sender
{
    [self startActivityIndicationInNavigationBar];
    
    [self saveOrganization];
}

- (IBAction)cancelAction:(id)sender
{
    [self completion];
}

- (IBAction)tap:(id)sender
{
    if (self.isKeyboardShown) {
        [self.view endEditing:YES];
    }
    [self hidePicker];
}

- (IBAction)tapOnCategory:(id)sender
{
    [self showPicker];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *image;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        image = editedImage ? editedImage : originalImage;
        
        // Save the new image (original or edited) to the Camera Roll
        if (editedImage != originalImage) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil , nil);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self changePicture:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AmazonServiceRequestDelegate

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@", request.requestTag, request.url);
    self.organization.image_thumbnail_url = request.url.absoluteString;
    
    [self updateOrganization];
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite
{
    float progress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
    NSLog(@"[DEBUG] Request tag:%@ url:%@ %f%%!", request.requestTag, request.url, progress * 100);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"[DEBUG] Request tag:%@ url:%@ Failed!", request.requestTag, request.url);
    [self stopActivityIndicationInNavigationBar];
}

#pragma mark - UIPickerDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRowsInComponent = [self.categories count];
    return numberOfRowsInComponent;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    OrganizationCategory *category = [self.categories objectAtIndex:row];
    NSString *title = category.name;
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.category = [self.categories objectAtIndex:row];
}

- (void)showPicker
{
    CGFloat pickerPoition = self.categoriesPicker.frame.origin.y;
    
    if (pickerPoition >= self.view.frame.size.height) {
        //[self.view addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
        [self movePickerUp:YES];
    }
}

- (void)hidePicker
{
    CGFloat pickerPoition = self.categoriesPicker.frame.origin.y;
    
    if (pickerPoition < self.view.frame.size.height) {
        //[self.view removeGestureRecognizer:self.tap]; // remove tap gesture
        [self movePickerUp:NO];
    }
}

- (void)movePickerUp:(BOOL)up
{
    const int movementDistance = pickerSize; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    [UIView animateWithDuration:movementDuration animations:^{
        NSLog(@"[DEBUG] <OrganizationSettingsViewController> Before movement of %d Picker Y position is %f", movement, self.categoriesPicker.frame.origin.y);
        CGRect frame = self.categoriesPicker.frame;
        self.categoriesPicker.frame = CGRectMake(frame.origin.x, frame.origin.y + movement, frame.size.width, frame.size.height);
        NSLog(@"[DEBUG] <OrganizationSettingsViewController> After movement of %d Picker Y position is %f", movement, self.categoriesPicker.frame.origin.y);
    }];
    
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    self.isKeyboardShown = YES;
    //[self.view addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:textView up:YES];
    
}


- (void)keyboardWillHide:(UITextView *)textView
{
    self.isKeyboardShown = NO;
    //[self.view removeGestureRecognizer:self.tap]; // remove tap gesture
    
    [self animateTextField:textView up:NO];
}

- (void) animateTextField:(UITextView *)textView up:(BOOL)up
{
    const int movementDistance = 216.0; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration animations:^{
        CGRect frame = self.view.frame;
        self.scrollView.frame = CGRectMake(0, 0, 320, frame.size.height + movement);
    }];
}

@end
