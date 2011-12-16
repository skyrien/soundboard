//
//  FacebookModule.m
//  Soundboard
//
//  Created by Ibrahim Shareef on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookModule.h"

@interface FacebookModule()

+(void)AuthenticateUser;

@end

static NSString* shareUrl;

@implementation FacebookModule

@synthesize facebook;

+(void)ShareUrl:(NSString*)url
{
    shareUrl = url;
}

-(void)InitializeFacebookComponent:(id<FBSessionDelegate>) delegate
{
    self->facebook = [[Facebook alloc] initWithAppId:@"130911066966920" andDelegate:delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self->facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self->facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}

-(void)AuthenticateUser
{
    if (![facebook isSessionValid]) {
        
        self->isAuthenticated = NO;
        
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_likes", 
                                @"read_stream",
                                @"publish_stream",
                                nil];
        
        [facebook authorize:permissions];
    }
    else
    {
        self->isAuthenticated  = YES;
    }
    
}

-(void)PostShareToUsersWall
{
    NSMutableDictionary* postparams = [NSMutableDictionary new];
    [postparams setObject:@"Ibrahim has shared a soundboard!" forKey:@"message"];
    [postparams setObject:@"Soundboard share" forKey:@"name"];
    [postparams setObject:shareUrl forKey:@"link"];
    [postparams setObject:@"Click here to see what Ibrahim has shared" forKey:@"description"];
    
    [facebook requestWithGraphPath:@"me/feed" andParams:postparams andHttpMethod:@"POST" andDelegate:self];
}


-(void)PublishSoundBoardShare
{
    [self AuthenticateUser];
    if (self->isAuthenticated)
    {
        [self PostShareToUsersWall];
    }
}

-(void)UserDidLogin
{
    NSLog(@"User successfully logged into Facebook!");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self PublishSoundBoardShare];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Facebook reqeuest failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    NSDictionary* dict = [error userInfo];
    
    if (nil != dict) 
    {
        for (NSString* key in dict) {
            NSLog(@"Key: %@ Value: %@", key, [dict objectForKey:key]);
        }
    } 
    
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result
{
    NSLog(@"Facebook request successfully completed!!");
}


@end
