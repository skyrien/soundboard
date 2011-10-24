//
//  EditSoundViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LocStrings.h"

#define MODE_EMPTY              0
#define MODE_READY              1
#define MODE_READYWITHNEWSOUND  2
#define MODE_PLAYING            3
#define MODE_RECORDING          4
#define MODE_RECORDINGPAUSED    5

@class EditSoundViewController;



@interface EditSoundViewController : UIViewController
{
    NSInteger mode;
    IBOutlet UIButton* recordButton;
    IBOutlet UIButton* playButton;
    IBOutlet UIButton* deleteButton;
    IBOutlet UIButton* soundTileButton; 
    IBOutlet UILabel* currentTime;
    IBOutlet UILabel* maxTime;
    
    NSString *currentSoundNumber;
    UInt32 soundId, newSoundId;
    UIActionSheet *confirmDeleteActionSheet;   
    NSURL* tempSound;
    AVAudioRecorder* theRecorder;
    AVAudioSession* session;
}

// This function loads a unique instance of the sound/image
- (void)loadSound:(UIButton *)sender;

// NAVIGATION BUTTONS

// Pressing "Done" writes the changes to disk (if there were any)
- (IBAction)doneEditing:(UIBarButtonItem *) sender;

// Pressing "Done" writes the changes to disk (if there were any)
- (IBAction)cancelEditing:(UIBarButtonItem *) sender;


// FUNCTION BUTTONS

// The play button plays the currently held sound. If there is no sound,
// this does nothing. Note, the play button becomes the "stop" button
// during recording.
- (IBAction)pressedPlayButton:(UIButton *) sender;

// This begins a recording immediately.
- (IBAction)pressedRecordButton:(UIButton *) sender;

- (IBAction)pressedDeleteButton:(UIButton *) sender;

- (IBAction)pressedSoundTileButton:(UIButton *) sender;


@end
