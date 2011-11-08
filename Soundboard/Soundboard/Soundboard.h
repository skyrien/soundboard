//
//  Soundboard.h
//  
//
//  Created by Alexander Joo on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Soundboard : NSObject {
    
    // Current Game Mode is represnted by this integer
//    NSInteger boardMode;
    
    // This is a string representing the theme name
    NSString* currentTheme;
    NSString* themeDescription;
    
    UIImage* currentThemePhoto;
    
    // This string represents the owner of the board
    NSString* boardOwnerId;
    
    // SoundIds are pointers to audio files. -loadTheme reads the file system to assign audio files. 
    UInt32 soundIds[9];
    
}

// BOARD MODE TRANSITION FUNCTIONS






// ACTIONS ON BOARD
-(void)setSoundNumber:(int)buttonNumber withCFURL:(CFURLRef)theURL;
-(void)clearSoundNumber:(int)buttonNumber;


// This function attempts to play the audio file corresponding to the button
-(void)playSound:(NSString *)buttonName;

@property(nonatomic, retain) NSString* boardOwnerId;
@property(nonatomic, retain) NSString* currentTheme;
@property(nonatomic, retain) NSString* themeDescription;
@property(nonatomic, retain) UIImage* currentThemePhoto;
//@property(nonatomic) NSInteger boardMode;

@end
