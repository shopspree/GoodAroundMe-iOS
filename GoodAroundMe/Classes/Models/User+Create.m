//
//  User+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "User+Create.h"
#import "ApplicationHelper.h"
#import "UserAPI.h"
#import "Company+Create.h"  
#import "Group+Create.h"
#import "Notification+Create.h"

@implementation User (Create)

+ (void)fullUserProfileByEmail:(NSString *)email managedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(User *user))success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI userByEmail:email success:^(NSDictionary *responseDictionary) {
        NSDictionary *userDictionary = responseDictionary[USER];
        User *user = [User userWithDictionary:userDictionary inManagedObjectContext:managedObjectContext];
        success(user);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (User *)userWithDictionary:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    if (userDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"email = %@", [userDictionary[PROFILE][PROFILE_EMAIL] description]];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
            [user setWithDictionary:userDictionary];
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            user = [matches lastObject];
            [user setWithDictionary:userDictionary];
        }
    }
    
    return user;
    
}

+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure;
{
    [UserAPI signUp:userDictionary success:^(NSDictionary *responseDictionary) {
        [User storeUser:responseDictionary[USER_LOGIN]];
        success();
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)signIn:(NSDictionary *)userDictionary success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI signIn:userDictionary success:^(NSDictionary *responseDictionary) {
        [User storeUser:responseDictionary];
        success();
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)signOut:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI signOut:^(NSDictionary *responseDictionary) {
        success();
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)changePassword:(NSString *)password confirmPassword:(NSString *)passwordConfirmation currentPassword:(NSString *)currentPassword success:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:currentPassword, @"current_password",
                                    password, @"password",
                                    passwordConfirmation, @"password_confirmation",nil];
    NSDictionary *requestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:USER, userDictionary, nil];
    [UserAPI changePassword:requestDictionary success:^(NSDictionary *responseDictionary) {
        success(responseDictionary);
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (User *)curretnUser:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSString *email = nil; // TO DO !!!
    
    if (email) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
        
        // Execute the fetch
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        
        if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible (unique!)
            // handle error
        } else if (![matches count]) { // none found, so let's create a Photo for that Flickr photo
            // do nothing
        } else { // found the Photo, just return it from the list of matches (which there will only be one of)
            user = [matches lastObject];
        }
        
    }
    
    return user;
}

+ (void)search:(NSString *)keyword page:(NSInteger)page success:(void (^)(NSArray *usersArray))success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI search:keyword page:page success:^(NSDictionary *responseDictionary) {
        if (responseDictionary) {
            NSMutableArray *usersArray = responseDictionary[USER][@"profiles"];
            
            success(usersArray);
        }
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)storeUser:(NSDictionary *)userDictionary
{
    if (userDictionary) {
        [[NSUserDefaults standardUserDefaults] setValue:userDictionary[USER_EMAIL] forKey:USER_EMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:userDictionary[USER_AUTHENTICATION] forKey:USER_AUTHENTICATION];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        
}

+ (BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validateName:(NSString*)name
{
    NSString *regex = @"[a-zA-ZàáâäãåąćęèéêëìíîïłńòóôöõøùúûüÿýżźñçčšžÀÁÂÄÃÅĄĆĘÈÉÊËÌÍÎÏŁŃÒÓÔÖÕØÙÚÛÜŸÝŻŹÑßÇŒÆČŠŽ∂ð .'-]{2,30}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [nameTest evaluateWithObject:name];
}

+ (BOOL)validatePassword:(NSString *)password
{
    BOOL isValid = NO;
    isValid = ([password length] > 0);
    return isValid;
}

- (void)setWithDictionary:(NSDictionary *)userDictionary
{
    if (YES) {
        if (userDictionary[PROFILE]) {
            NSDictionary *profileDictionary = userDictionary[PROFILE];
            self.email = [profileDictionary[PROFILE_EMAIL] description];
            self.full_name = [profileDictionary[PROFILE_FULL_NAME] description];
            self.firstname = [profileDictionary[PROFILE_FIRST_NAME] description];
            self.lastname = [profileDictionary[PROFILE_LAST_NAME] description];
            self.thumbnailURL = [profileDictionary[PROFILE_THUMBNAIL_URL] description];
            self.pictureURL = [profileDictionary[PROFILE_PICTURE_URL] description];
            self.created_at = [ApplicationHelper dateFromString:[profileDictionary[PROFILE_CREATED_AT] description]];
            self.updated_at = [ApplicationHelper dateFromString:[profileDictionary[PROFILE_UPDATED_AT] description]];
        }
        
        if (userDictionary[JOB_PROFILE]) {
            NSDictionary *jobProfile = userDictionary[JOB_PROFILE];
            self.jobTitle = [jobProfile[JOB_PROFILE_TITLE] description];
            
            Company *company = [Company companyWithName:[jobProfile[JOB_PROFILE_ORGANIZATION] description] inManagedObjectContext:self.managedObjectContext];
            self.company = company;            
        }
        
        if (userDictionary[GROUP]) {
            NSDictionary *groupDictionary = userDictionary[GROUP];
            Group *group = [Group groupWithName:[groupDictionary[GROUP_NAME] description] inManagedObjectContext:self.managedObjectContext];
            self.group = group;

        }
    }
}

- (void)saveUser:(NSDictionary *)userDictionary success:(void (^)(User *user))success failure:(void (^)(NSDictionary *errorData))failure
{
    self.jobTitle = userDictionary[JOB_PROFILE][JOB_PROFILE_TITLE];
    self.group = [Group groupWithName:userDictionary[GROUP][GROUP_NAME] inManagedObjectContext:self.managedObjectContext];
    
    [UserAPI updateUser:self success:^(NSDictionary *responseDictionary) {
        [self setWithDictionary:responseDictionary];
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
    
    
    
}

- (void)notifications:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI notificationsForUser:self success:^(NSDictionary *responseDictionary) {
        for (NSDictionary *notificationDictionary in responseDictionary[@"Notifications"]) {
            Notification *notification = [Notification notificationWithDictionary:notificationDictionary[NOTIFICATION] inManagedObjectContext:self.managedObjectContext];
            notification.user = self;
            
            success();
        }
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }]; 
}

- (void)acknowledgeNotifications:(void (^)())success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI acknowledgeNotificationsForUser:self success:^(NSDictionary *responseDictionary) {
        for (NSDictionary *notificationDictionary in responseDictionary[@"Notifications"]) {
            success();
        }
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

- (NSData *)toJSON
{
    NSDictionary *profileDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.firstname, PROFILE_FIRST_NAME,
                                       self.lastname, PROFILE_LAST_NAME,
                                       self.email, PROFILE_EMAIL,
                                       self.pictureURL, PROFILE_PICTURE_URL,
                                       self.thumbnailURL, PROFILE_THUMBNAIL_URL, nil];
    
    NSString *groupName = self.group ? self.group.name : nil;
    NSDictionary *groupDictionary = [NSDictionary dictionaryWithObjectsAndKeys:groupName, @"name", nil];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:profileDictionary, PROFILE,
                                groupDictionary, GROUP, nil];
    
    NSData *jsonData = [ApplicationHelper constructJSON:dictionary];
    return jsonData;
}

@end
