//
//  Soundboard.h
//  
//
//  Created by Alexander Joo on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// UI STRING DEFINITIONS
#define LOC_TITLE @"Soundboard!"
#define LOC_CANCEL @"Cancel"
#define LOC_EDITBOARD @"Edit this board"
#define LOC_SHARE_EMAIL @"Share by email"
#define LOC_SHARE_FACEBOOK @"Share on Facebook"
#define LOC_DELETEBOARD @"Delete this board..."

#define MODE_EMPTY          0
#define MODE_BOARDLOADED    1
#define MODE_READY          2
#define MODE_EDITMODE       3


@interface Soundboard : NSObject {
    
    UIButton* button1;
    UIButton* button2;    
    UIButton* button3;
    UIButton* button4;
    UIButton* button5;
    UIButton* button6;
    UIButton* button7;
    UIButton* button8;
    UIButton* button9;
    
    // Current Game Mode is represnted by this integer
    NSInteger boardMode;
    
    // This is a string representing the theme name
    NSString* currentTheme;
    
    // This string represents the owner of the board
    NSString* boardOwnerId;
    
    // SoundIds are pointers to audio files. -loadTheme reads the file system to assign audio files. 
    UInt32 soundIds[9];
    
}

// BOARD MODE TRANSITION FUNCTIONS

// actionButtonPressed calls this function when the user chooses to enter edit mode
-(void)enterEditMode;




// ACTIONS ON BOARD
-(void)setSoundNumber:(int)buttonNumber withCFURL:(CFURLRef)theURL;

// This function attempts to play the audio file corresponding to the button
-(void)playSound:(NSString *)buttonName;

//@property(nonatomic) NSString* currentTheme;
//@property(nonatomic, retain) UIButton* button0;
@property(nonatomic, retain) UIButton* button1;
@property(nonatomic, retain) UIButton* button2;
@property(nonatomic, retain) UIButton* button3;
@property(nonatomic, retain) UIButton* button4;
@property(nonatomic, retain) UIButton* button5;
@property(nonatomic, retain) UIButton* button6;
@property(nonatomic, retain) UIButton* button7;
@property(nonatomic, retain) UIButton* button8;
@property(nonatomic, retain) UIButton* button9;
@property(nonatomic, retain) NSString* boardOwnerId;
@property(nonatomic, retain) NSString* currentTheme;

@end
