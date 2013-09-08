//
//  User+Create.m
//  TempName
//
//  Created by asaf ahi-mordehai on 6/25/13.
//  Copyright (c) 2013 asaf ahi-mordehai. All rights reserved.
//

#import "User+Create.h"
#import "CoreDataFactory.h"
#import "ApplicationHelper.h"
#import "UserAPI.h"
#import "Organization+Create.h"
#import "OrganizationAPI.h"

@implementation User (Create)

+ (User *)userByEmail:(NSString *)email inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext success:(void (^)(User *user))success failure:(void (^)(NSString *message))failure
{
    User *user = [User fetchUserByEmail:email managedObjectContext:managedObjectContext];
    
    [UserAPI userByEmail:email success:^(NSDictionary *responseDictionary) {
        NSDictionary *userDictionary = responseDictionary[USER];
        User *user = [User userWithDictionary:userDictionary inManagedObjectContext:managedObjectContext];
        success(user);
        
    } failure:^(NSString *message) {
        failure(message);
    }];
    
    return user;
}

+ (User *)fetchUserByEmail:(NSString *)email managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    User *user = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *matches = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([matches count] == 1){
        user = [matches lastObject];
    }
    
    return user;
}

+ (User *)userWithDictionary:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    if (userDictionary) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"email" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"email = %@", [userDictionary[USER_EMAIL] description]];
        
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

+ (void)signUp:(NSDictionary *)userDictionary success:(void (^)(User *user))success failure:(void (^)(NSString *message))failure;
{
    [UserAPI signUp:userDictionary success:^(NSDictionary *responseDictionary) {
        [User storeUser:responseDictionary];
        
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            NSDictionary *userDictionary = responseDictionary[USER];
            User *authenticatedUser = [User userWithDictionary:userDictionary inManagedObjectContext:managedObjectContext];
            success(authenticatedUser);
        }];
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (void)signIn:(NSDictionary *)userDictionary success:(void (^)(User *user))success failure:(void (^)(NSDictionary *errorData))failure
{
    [UserAPI signIn:userDictionary success:^(NSDictionary *responseDictionary) {
        [User storeUser:responseDictionary];
        
        [[CoreDataFactory getInstance] context:^(NSManagedObjectContext *managedObjectContext) {
            NSDictionary *userDictionary = responseDictionary[USER];
            User *authenticatedUser = [User userWithDictionary:userDictionary inManagedObjectContext:managedObjectContext];
            success(authenticatedUser);
        }];
        
    } failure:^(NSDictionary *errorData) {
        failure(errorData);
    }];
}

+ (void)signOut:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [UserAPI signOut:^(NSDictionary *responseDictionary) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_AUTHENTICATION];
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

+ (User *)currentUser:(NSManagedObjectContext *)context
{
    User *user = nil;
    
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
    
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
    if (userDictionary) {
        self.email = [userDictionary[USER_EMAIL] description];
        self.firstname = [userDictionary[USER_FIRST_NAME] description];
        self.lastname = [userDictionary[USER_LAST_NAME] description];
        self.thumbnailURL = [userDictionary[USER_THUMBNAIL_URL] description];
        self.created_at = [ApplicationHelper dateFromString:[userDictionary[USER_CREATED_AT] description]];
        self.updated_at = [ApplicationHelper dateFromString:[userDictionary[USER_UPDATED_AT] description]];
        self.orgOperator = [NSNumber numberWithBool:[userDictionary[USER_OPERATOR] isEqualToString:@"true"]];
        
        if (userDictionary[USER_FOLLOWING]) {
            self.following = [NSSet set];
            for (NSDictionary *orgazniationDictionary in userDictionary[USER_FOLLOWING]) {
                Organization *organization = [Organization organizationWithDictionary:orgazniationDictionary[ORGANIZATION] inManagedObjectContext:self.managedObjectContext];
                [self addFollowingObject:organization];
            }
        }
        
        if (userDictionary[ORGANIZATION]) {
            Organization *organization = [Organization organizationWithDictionary:userDictionary[ORGANIZATION] inManagedObjectContext:self.managedObjectContext];
            self.organization = organization;
        }
    }
}



- (void)changePassword:(NSString *)password confirmPassword:(NSString *)passwordConfirmation currentPassword:(NSString *)currentPassword success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:currentPassword, @"current_password",
                                    password, @"password",
                                    passwordConfirmation, @"password_confirmation",nil];
    NSDictionary *requestDictionary = [NSDictionary dictionaryWithObjectsAndKeys:userDictionary, USER, nil];
    
    [UserAPI changePassword:requestDictionary forEmail:self.email success:^(NSDictionary *responseDictionary) {
        NSLog(@"[DEBUG] <UserAPI> Password changed successfully for %@ %@", self.firstname, self.lastname);
        success(responseDictionary);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)updateUser:(void (^)(User *user))success failure:(void (^)(NSString *message))failure
{
    [UserAPI updateUser:self success:^(NSDictionary *responseDictionary) {
        NSDictionary *userDictionary = responseDictionary[USER];
        [self setWithDictionary:userDictionary];
        success(self);
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)follow:(Organization *)organization success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [OrganizationAPI follow:organization.uid success:^(NSDictionary *reponseDictionary) {
        organization.is_followed = [NSNumber numberWithBool:YES];
        organization.followers_count = [NSNumber numberWithInteger:([organization.followers_count integerValue] + 1)];
        [self addFollowingObject:organization];
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (void)unfollow:(Organization *)organization success:(void (^)())success failure:(void (^)(NSString *message))failure
{
    [OrganizationAPI unfollow:organization.uid success:^(NSDictionary *reponseDictionary) {
        organization.is_followed = [NSNumber numberWithBool:NO];
        organization.followers_count = [NSNumber numberWithInteger:([organization.followers_count integerValue] - 1)];
        [self removeFollowingObject:organization];
        
        success();
    } failure:^(NSString *message) {
        failure(message);
    }];
}

- (NSData *)toJSON
{
    NSDictionary *profileDictionary = [NSDictionary dictionaryWithObjectsAndKeys:self.firstname, USER_FIRST_NAME,
                                       self.lastname, USER_LAST_NAME,
                                       self.email, USER_EMAIL,
                                       self.thumbnailURL, USER_THUMBNAIL_URL, nil];
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:profileDictionary, USER, nil];
    
    NSData *jsonData = [ApplicationHelper constructJSON:dictionary];
    return jsonData;
}

- (NSString *)getFullName
{
    NSString *fullName = [NSString stringWithFormat:@"%@ %@", self.firstname, self.lastname];
    return fullName;
}

@end
