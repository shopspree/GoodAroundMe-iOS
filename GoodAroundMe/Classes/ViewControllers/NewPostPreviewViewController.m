//
//  NewPostPreviewViewController.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/15/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NewPostPreviewViewController.h"
#import "Category.h"
#import "Post+Create.h"
#import "User+Create.h" 
#import "Company.h"

@interface NewPostPreviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation NewPostPreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    self.contentLabel.alpha= 0.5;
    
    self.categoryLabel.textColor = [UIColor blackColor];
    self.categoryLabel.backgroundColor = [UIColor whiteColor];
    self.categoryLabel.alpha= 0.5;
    
    self.companyLabel.textColor = [UIColor blackColor];
    self.companyLabel.backgroundColor = [UIColor whiteColor];
    self.companyLabel.alpha= 0.5;
    
    self.locationLabel.textColor = [UIColor blackColor];
    self.locationLabel.backgroundColor = [UIColor whiteColor];
    self.locationLabel.alpha= 0.5;
}

- (void)setPostDictionary:(NSMutableDictionary *)postDictionary
{
    [super setPostDictionary:postDictionary];
    
    NSString *content = [self.postDictionary objectForKey:CONTENT];
    self.contentLabel.text = content;
    
    Category *category = [self.postDictionary objectForKey:CATEGORY];
    NSString *categoryString = category.name;
    NSString *subcategoryString = [self.postDictionary objectForKey:SUBCATEGORY];
    self.categoryLabel.text = [NSString stringWithFormat:@"%@ | %@", categoryString, subcategoryString];
    
    User *currentUser = [User curretnUser:category.managedObjectContext];
    NSString *companyName = currentUser.company.name;
    self.companyLabel.text = companyName;
    
    NSString *defaultLocation = companyName;
    self.locationLabel.text = defaultLocation;
}



#pragma mark - storyboard

- (IBAction)xButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)postButtonClicked:(id)sender
{
    NSManagedObjectContext *managedObjectContext = ((Category *)[self.postDictionary objectForKey:CATEGORY]).managedObjectContext;
    [Post newPost:self.postDictionary managedObjectContext:managedObjectContext success:^(Post *post) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSDictionary *errorData) {
        // TO DO
    }];
}

- (IBAction)unwindFromModal:(UIStoryboardSegue *)segue
{
    // get results out of vc, which I presented
    if ([segue.identifier isEqualToString:@"PostCategory"]) {
        if ([segue.sourceViewController respondsToSelector:@selector(postDictionary)]) {
            self.postDictionary = [segue.sourceViewController performSelector:@selector(postDictionary)];
            
        }
    }
    
    return;
}

@end

