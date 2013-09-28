//
//  OrganizationProfileCell.h
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 8/18/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Organization+Create.h"

@protocol OrganizationProfileCellDelegate <NSObject>

- (IBAction)goToOrganizationInformation:(id)sender;

@end


@interface OrganizationProfileCell : UITableViewCell

@property (nonatomic, strong) Organization *organization;
@property (strong, nonatomic) id<OrganizationProfileCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *fundsLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end
