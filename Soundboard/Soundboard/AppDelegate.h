//
//  AppDelegate.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
//  <THIS IS A TEST CHANGE TO SEE SMARTSVN IN ACTION>

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "FacebookModule.h"
#import "FBConnect.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>
{
    FacebookModule* fbm;
}

@property (nonatomic,retain) FacebookModule* fbm;
@property (strong, nonatomic) UIWindow *window;

@end
