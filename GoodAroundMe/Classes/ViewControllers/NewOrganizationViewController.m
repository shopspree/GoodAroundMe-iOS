//
//  NewOrganizationViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/5/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "NewOrganizationViewController.h"

@interface NewOrganizationViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *organizationNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation NewOrganizationViewController

static NSString *AboutPlaceHolder = @"About ...";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.aboutTextView.delegate = self;
    self.aboutTextView.text = AboutPlaceHolder;
}

- (void)addNewOrganization
{
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        [self addNewOrganization];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.aboutTextView.text = @"";
    self.aboutTextView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if (self.aboutTextView.text.length == 0){
        self.aboutTextView.textColor = [UIColor lightGrayColor];
        self.aboutTextView.text = AboutPlaceHolder;
        [self.aboutTextView resignFirstResponder];
    }
}

@end
