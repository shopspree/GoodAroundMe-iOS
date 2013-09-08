//
//  NewOrganizationViewController.m
//  GoodAroundMe
//
//  Created by asaf ahi-mordehai on 9/5/13.
//  Copyright (c) 2013 GoodAroundMe. All rights reserved.
//

#import "NewOrganizationViewController.h"

@interface NewOrganizationViewController ()

@end

@implementation NewOrganizationViewController

- (void)saveOrganization
{
    [self createOrganization];
}


- (void)createOrganization
{
    self.organization = [NSEntityDescription insertNewObjectForEntityForName:@"Organization" inManagedObjectContext:self.managedObjectContext];
    self.organization.name = self.organizationName;
    self.organization.location = self.organizationLocation;
    self.organization.about = self.organizationAbout;
    
    [self.organization create:^{
        [self uploadImageToAmazon];
    } failure:^(NSString *message) {
        [self fail:@"Create Organization" withMessage:message];
    }];
    
}

@end
