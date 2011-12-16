//
//  AppDelegate.m
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"



@implementation AppDelegate

@synthesize window = _window, fbm;

-(FacebookModule*) fbm
{
    if (!self->fbm)
    {
        fbm = [[FacebookModule alloc] init];
    }
    return  self->fbm;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // OVERRIDE POINT FOR LOADING APPLICATION
    [self.fbm InitializeFacebookComponent:self];
    
    NSString* localPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSLog(@"Bundle path: %@", localPath);
    
    return YES;
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    NSLog(@"Open url scheme: %@", [url scheme]);
    if ([[url scheme] isEqualToString:@"db-ych32k07fi427wq"])
    {
        NSLog(@"OpenURL being handled by dropbox");
        if ([[DBSession sharedSession] handleOpenURL:url]) {
            if ([[DBSession sharedSession] isLinked]) {
                NSLog(@"App linked successfully!");
                // At this point you can start making API calls
            }
            return YES;
        }
        return NO;
    }
    else
    {
        return [self.fbm.facebook handleOpenURL:url]; 
    }
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"Open url scheme: %@", [url scheme]);
    
    if ([[url scheme] isEqualToString:@"db-ych32k07fi427wq"])
    {
        NSLog(@"OpenURL being handled by dropbox");
        if ([[DBSession sharedSession] handleOpenURL:url]) {
            if ([[DBSession sharedSession] isLinked]) {
                NSLog(@"App linked successfully!");
                // At this point you can start making API calls
            }
            return YES;
        }
        return NO;
    }
    else
    {
        NSLog(@"OpenURL being handled by facebook");
        return [self.fbm.facebook handleOpenURL:url]; 
    } 
}

- (void)fbDidLogin {
    
    NSLog(@"User successfully logged in!");
    [self.fbm UserDidLogin];
}

- (void)fbDidNotLogin:(BOOL)cancelled;
{
    NSLog(@"User did not log in!");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    // THIS SHOULD POP TO THE ROOT VIEW CONTROLLER, THEN ADD A HOME VIEW
    // AND A BOARDVIEWCONTROLLER CORRESPONDING TO THE NEW BOARD AT THE URL
    
    return NO;
    
}*/

@end
