//
//  BoardViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MODE_EMPTY          0
#define MODE_BOARDLOADED    1
#define MODE_READY          2
#define MODE_EDITMODE       3

// UI STRING DEFINITIONS
#define LOC_TITLE @"Soundboard!"
#define LOC_CANCEL @"Cancel"
#define LOC_EDITBOARD @"Edit this board"
#define LOC_SHARE_EMAIL @"Share by email"
#define LOC_SHARE_FACEBOOK @"Share on Facebook"
#define LOC_DELETEBOARD @"Delete this board..."

@interface BoardViewController : UIViewController
{
     // Collection of buttons in IB - These are all sound buttons.
    //IBOutlet UIButton* button0; -- REMOVED FROM UI
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;    
    IBOutlet UIButton* button3;
    IBOutlet UIButton* button4;
    IBOutlet UIButton* button5;
    IBOutlet UIButton* button6;
    IBOutlet UIButton* button7;
    IBOutlet UIButton* button8;
    IBOutlet UIButton* button9;
    
    // This file represents the background photo (is this needed??)
    IBOutlet UIImageView* background;

    // Current Game Mode is represnted by this integer
    NSInteger boardMode;
    
    // This is a string representing the theme name
    NSString* currentTheme;

    // This string represents the owner of the board
    NSString* boardOwnerId;
    bool userIsBoardOwner;
    
    // 
    UIActionSheet* boardActionSheet;
    
    // SoundIds are pointers to audio files. -loadTheme reads the file system to assign audio files. 
    UInt32 soundIds[9];
}

// This function is called whenever an audio button is pressed
-(IBAction)buttonPressed:(UIButton *)sender;

// Pressing the action button (the one in the upper right corner calls this function
-(IBAction)actionButtonPressed:(UIBarButtonItem *)sender;

// actionButtonPressed calls this function when the user chooses to enter edit mode
-(void)enterEditMode;

// This function attempts to play the audio file corresponding to the button
-(void)playSound:(NSString *)buttonName;

// This function is called on the button when the Long Press Gesture Recognizer
// determines that an event has occured on this button.
-(void)longPress:(NSString *)buttonName;

// This function loads the theme defined by "themename"
-(void)loadTheme:(NSString *)themeName;

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

@end
