//
//  BoardViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Soundboard.h"
#import "EditSoundViewController.h"
#import "EditViewController.h"
#import "LocStrings.h"

// BOARD MODES
#define MODE_EMPTY              0
#define MODE_READY              1
#define MODE_EDIT               2
#define MODE_RECORDING          3

@interface BoardViewController : UIViewController
{
     // Collection of buttons in IB - These are all sound buttons.
    //IBOutlet UIButton* button0; -- REMOVED FROM UI
//    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;    
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    IBOutlet UIButton *button7;
    IBOutlet UIButton *button8;
    IBOutlet UIButton *button9;
    IBOutlet UIBarButtonItem *actionButton;
    IBOutlet UIStoryboardSegue *editSegue;
    
    // This file represents the background photo (is this needed??)
    IBOutlet UIImageView *background;
    
    IBOutlet EditSoundViewController *EditSoundVC;
    IBOutlet UILongPressGestureRecognizer *longPressGR;

    // Access variables
    Soundboard *theBoard;
    UIActionSheet *boardActionSheet, *confirmDeleteActionSheet;
    UINavigationController* navController;
    NSInteger mode;
    AVAudioSession *session;
    
    // Variables
    bool        userIsBoardOwner;
    int         buttonIndexFacebook,
                buttonIndexEmail,
                buttonIndexEdit,
                buttonIndexDelete;
}

// This function is called whenever an audio button is pressed
-(IBAction)buttonPressed:(UIButton *)sender;

// Pressing the action button (the one in the upper right corner calls this function.
// Note that if the board is in edit mode, then this could be a "Save" button.
-(IBAction)actionButtonPressed:(UIBarButtonItem *)sender;

// This function is called on the button when the Long Press Gesture Recognizer
// determines that an event has occured on this button.
-(IBAction)longPress:(UILongPressGestureRecognizer *)sender;


//-(IBAction)doneEditing:(UIBarButtonItem *) sender;
//-(IBAction)cancelEditing:(UIBarButtonItem *) sender;

//MODE TRANSITIONS

// actionButtonPressed calls the Enter to edit function when the user chooses to enter edit mode
-(void)enterEditMode;
-(void)exitEditMode;


// This function loads the theme from disk
-(void)loadTheme:(NSString *)themeName;

@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) IBOutlet EditSoundViewController *EditSoundVC;

@end
