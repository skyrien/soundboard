//
//  EditSoundViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "LocStrings.h"
#import "ThemeManager.h"
#import "BoardViewController.h"

#define MODE_EMPTY              0
#define MODE_READY              1
#define MODE_READYWITHNEWSOUND  2
#define MODE_PLAYING            3
#define MODE_RECORDING          4
#define MODE_RECORDINGPAUSED    5

#define PLAY_TIMER_UPDATE_RATE 40 //FRAMES PER SECOND FOR THE PLAY TIMER

@class EditSoundViewController;

@interface EditSoundViewController : UIViewController <UIImagePickerControllerDelegate>
{
    IBOutlet UIButton* recordButton;
    IBOutlet UIButton* playButton;
    IBOutlet UIButton* deleteButton;
    IBOutlet UIButton* soundTileButton; 
    IBOutlet UILabel* currentTime;
    IBOutlet UILabel* maxTime;
    IBOutlet UIProgressView* progressBar;
    IBOutlet UINavigationItem* navigationItem;
    IBOutlet UINavigationBar* navigationBar;
    IBOutlet UIBarButtonItem* cancelButton;
    IBOutlet UIBarButtonItem* saveButton;

    //    IBOutlet BoardViewController* theBoardView;
    // Variables and stuff
    NSFileManager* fileManager;
    NSInteger mode;
    ThemeManager* themeManager;
    NSTimer* playTimer;
    NSString* currentSoundNumber;
    NSString* currentThemeName;
    UInt32 soundId, newSoundId;
    UIActionSheet* confirmDeleteActionSheet;
    UIActionSheet* photoSourceActionSheet;
    NSURL* tempSound;
    AVAudioRecorder* theRecorder;
    AVAudioSession* session;
    UIImagePickerController* theCamera;
    int tickNumber;
    bool isPlaying, hasNewImage;
}

// This function loads a sound from a specific theme
- (void)loadSound:(NSString*) soundNumber FromTheme:(NSString*)themeName;

- (int)updatePlayTimer;

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
