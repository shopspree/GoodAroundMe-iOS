//
//  TempViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/29/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "TempViewController.h"

@interface TempViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic) BOOL isKeyboardShown;
@property (nonatomic) BOOL isCommentMode;
@property (weak, nonatomic) IBOutlet UITextField *commentInputTextField;

@property (nonatomic) CGRect frame;

@end

@implementation TempViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
     // register for keyboard notifications
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillShow:)
                                                  name:UIKeyboardWillShowNotification
                                                object:self.view.window];
     
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillHide:)
                                                  name:UIKeyboardWillHideNotification
                                                object:self.view.window];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    if (self.isKeyboardShown)
        self.view.frame = self.frame;
    
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = @"Test 1 2 3";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}


#pragma mark - Keyboard

- (void)keyboardWillShow:(UITextView *)textView
{
    [self animateTextField:textView up:YES];
}


- (void)keyboardWillHide:(UITextView *)textView
{
    [self animateTextField:textView up:NO];
}

- (void) animateTextField:(UITextView *)textView up:(BOOL)up
{
    self.isKeyboardShown = up;
    
    const int keyboardHeight = 216.0f; // tweak as needed
    const float movementDuration = 0.27f; // tweak as needed
    
    int movement = up ? -1 * keyboardHeight : keyboardHeight;
    
    CGRect frame = self.view.frame;
    self.frame = CGRectMake(frame.origin.x,
                            frame.origin.y,
                            frame.size.width,
                            frame.size.height + movement);
    
    [UIView animateWithDuration:movementDuration animations:^{
        self.bottomView.frame = CGRectOffset(self.bottomView.frame, 0, movement);
        self.view.frame = self.frame;
    }];
}

@end
