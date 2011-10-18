//
//  BoardViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Soundboard.h"

// UI STRING DEFINITIONS
#define LOC_TITLE @"Soundboard!"
#define LOC_CANCEL @"Cancel"
#define LOC_EDITBOARD @"Edit this board"
#define LOC_SHARE_EMAIL @"Share by email"
#define LOC_SHARE_FACEBOOK @"Share on Facebook"
#define LOC_DELETEBOARD @"Delete this board"
#define LOC_CONFIRMDELETE @"Are you sure you want to delete this board?"
#define LOC_FINALCONFIRMATION @"Yes, delete this board"

@interface BoardViewController : UIViewController
{
     // Collection of buttons in IB - These are all sound buttons.
    //IBOutlet UIButton* button0; -- REMOVED FROM UI
    IBOutlet UIButton *button0;
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;    
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    IBOutlet UIButton *button7;
    IBOutlet UIButton *button8;
    IBOutlet UIButton *button9;
    
    // This file represents the background photo (is this needed??)
    IBOutlet UIImageView *background;
    IBOutlet UILongPressGestureRecognizer *longPressGR;
    Soundboard *theBoard;

    bool userIsBoardOwner;
    UIActionSheet *boardActionSheet, *confirmDeleteActionSheet;
    
    
    // Variables
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

// This function loads the theme from disk
-(void)loadTheme:(NSString *)themeName;

@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGR;

@end