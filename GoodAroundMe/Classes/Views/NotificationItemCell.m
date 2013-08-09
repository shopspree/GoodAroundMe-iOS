//
//  NotificationItemCell.m
//  TempName
//
//  Created by asaf ahi-mordehai on 7/13/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "NotificationItemCell.h"

@interface NotificationItemCell()

@property (weak, nonatomic) IBOutlet UILabel *notificationCountLabel;

@end

@implementation NotificationItemCell

- (void)setNotificationCount:(NSInteger)notificationCount
{
    _notificationCount = notificationCount;
    
    if (notificationCount > 20) {
        self.notificationCountLabel.text = @"20+";
    } else if (notificationCount > 0) {
        self.notificationCountLabel.text = [NSString stringWithFormat:@"%d+", notificationCount];
    }
}

@end
