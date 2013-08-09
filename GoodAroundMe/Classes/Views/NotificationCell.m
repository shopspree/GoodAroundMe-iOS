//
//  NotificationCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/23/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NotificationCell.h"

@interface NotificationCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *notificationText;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
