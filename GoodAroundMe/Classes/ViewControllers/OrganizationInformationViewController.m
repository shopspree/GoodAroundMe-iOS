//
//  OrganizationInformationViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/25/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "OrganizationInformationViewController.h"
#import "OrganizationSectionHeaderView.h"
#import "OrganizationAboutCell.h"
#import "OrganizationAboutView.h"

@interface OrganizationInformationViewController ()

@property (strong, nonatomic) NSArray *sections;
@property (nonatomic) NSInteger headerHeight;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation OrganizationInformationViewController

- (NSArray *)sections
{
    if (!_sections) {
        _sections = [NSArray arrayWithObjects:@"About", nil];
    }
    return _sections;
}

- (NSInteger)headerHeight
{
    if (_headerHeight == 0) {
        OrganizationSectionHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:[[OrganizationSectionHeaderView class] description] owner:nil options:nil] lastObject];
        _headerHeight = view.frame.size.height;
    }
    
    return _headerHeight;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:[[OrganizationSectionHeaderView class] description] owner:nil options:nil] lastObject];
    }
    return _headerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSectionsInTableView = [self.sections count];
    return numberOfSectionsInTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRowsInSection = 1;
    return numberOfRowsInSection;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AboutCellIdentifier = @"OrganizationAboutCell";
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:AboutCellIdentifier forIndexPath:indexPath];
        OrganizationAboutCell *organizationAboutCell = (OrganizationAboutCell *)cell;
        organizationAboutCell.about = self.organization.about;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrganizationSectionHeaderView *view = (OrganizationSectionHeaderView *)self.headerView;
    view.headerLabel.text = [self.sections objectAtIndex:section];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat heightForHeaderInSection = self.headerHeight;
    return heightForHeaderInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = tableView.rowHeight;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        OrganizationAboutCell *cell = [[OrganizationAboutCell alloc] init];
        OrganizationAboutView *aboutView = cell.aboutView;
        height = [aboutView sizeToFitText:self.organization.about];
    }
    
    return height;
}

@end
