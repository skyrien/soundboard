//
//  FacebookModule.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 11/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface FacebookModule : NSObject <FBRequestDelegate>
{
    Facebook* facebook;
    BOOL isAuthenticated;
}

@property (nonatomic, retain) Facebook* facebook;

-(void)InitializeFacebookComponent:(id<FBSessionDelegate>) delegate;
-(void)UserDidLogin;
-(void)PublishSoundBoardShare:(NSString*)link;



@end
