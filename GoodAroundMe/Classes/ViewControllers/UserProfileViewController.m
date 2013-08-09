//
//  UserProfileViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/7/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "UserProfileViewController.h"
#import "Group+Create.h"
#import "CoreDataFactory.h"

@interface UserProfileViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User *user;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *teamTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;


@end

@implementation UserProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
    self.titleTextField.returnKeyType = UIReturnKeyDone;
    self.titleTextField.delegate = self;
    
    self.teamTextField.returnKeyType = UIReturnKeyDone;
    self.teamTextField.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (! self.managedObjectContext) {
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            self.managedObjectContext = managedObjectContext;
            [self retrieveUser];
        } get:^(NSManagedObjectContext *managedObjectContext) {
            self.managedObjectContext = managedObjectContext;
            [self retrieveUser];
        }];
    } else {
        [self retrieveUser];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
}

- (void)setUser:(User *)user
{
    _user = user;
    if (user) {
        self.usernameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstname, user.lastname];
        [self.userImage setImageWithURL:[NSURL URLWithString:user.thumbnailURL] placeholderImage:[UIImage imageNamed:@"Default.png"]];
        if (! [user.jobTitle isEqualToString:@"<null>"]) {
            self.titleTextField.text = user.jobTitle;
        }
        self.teamTextField.text = user.group.name;
    }
}

- (void)retrieveUser
{
    if (self.managedObjectContext && self.email) {
        [User fullUserProfileByEmail:self.email managedObjectContext:self.managedObjectContext success:^(User *user) {
            self.user = user;
        } failure:^(NSDictionary *errorData) {
            // TO DO
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UserSettings"]) {
        
    }
}

#pragma mark - storyboard

- (IBAction)followButtonClicked:(id)sender
{
}

- (IBAction)contactButtonClicked:(id)sender
{
}

- (IBAction)moreButtonClicked:(id)sender
{
    // TO DO
}

- (IBAction)settingButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"UserSettings" sender:sender];
}

- (IBAction)menuButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:@"Menu" sender:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    [self.view addGestureRecognizer:self.tap]; // add tap gesture to tap away from the keyboard
    
    [self animateTextField:textView up:YES];
}


- (void)keyboardWillHide:(UITextView *)textView
{
    [self.view removeGestureRecognizer:self.tap]; // remove tap gesture
    
    [self animateTextField:textView up:NO];
}

- (void) animateTextField:(UITextView *)textView up:(BOOL)up
{
    const int movementDistance = 216.0; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView animateWithDuration:movementDuration animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y + movement,
                                     self.view.frame.size.width,
                                     self.view.frame.size.height);
    }];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	[textField resignFirstResponder];
    
    NSDictionary *jobProfileDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.titleTextField.text, JOB_PROFILE_TITLE, nil];
    NSDictionary *groupDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.teamTextField.text, GROUP_NAME, nil];
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:jobProfileDictionary, JOB_PROFILE,
                                    groupDictionary, GROUP, nil];
    [self.user saveUser:userDictionary success:^(User *user) {
        return;
    } failure:^(NSDictionary *errorData) {
        // TO DO
    }];
    
	return YES;
    
}


@end
