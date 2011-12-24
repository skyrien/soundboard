//
//  BoardViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Soundboard.h"
#import "EditSoundViewController.h"
#import "EditViewController.h"
#import "LocStrings.h"
#import "ThemeManager.h"
#import "DropBoxModule.h"
#import "GADBannerView.h"
#import "FacebookModule.h"

// BOARD MODES
#define MODE_EMPTY              0
#define MODE_READY              1
#define MODE_EDIT               2

@class BoardViewController;

@interface BoardViewController : UIViewController <ADBannerViewDelegate, DBRestClientDelegate, DBSessionDelegate>
{
     // Collection of buttons in IB - These are all sound buttons.
    IBOutlet UIButton *button1;
    IBOutlet UIButton *button2;    
    IBOutlet UIButton *button3;
    IBOutlet UIButton *button4;
    IBOutlet UIButton *button5;
    IBOutlet UIButton *button6;
    IBOutlet UIButton *button7;
    IBOutlet UIButton *button8;
    IBOutlet UIButton *button9;
    IBOutlet UIButton *infoButton;
    IBOutlet UIBarButtonItem *actionButton;
    IBOutlet UIStoryboardSegue *editSegue;
    IBOutlet EditSoundViewController *EditSoundVC;
//    IBOutlet UILongPressGestureRecognizer *longPressGR;

    // Access variables
    Soundboard *theBoard;
    UIActionSheet *boardActionSheet, *confirmDeleteActionSheet;
    UINavigationController* navController;
    NSInteger mode;
    AVAudioSession *session;
    ThemeManager* themeManager;
    GADBannerView *adBannerView;
    DropBoxModule* dbm;
    FacebookModule* fbm;
    
    // Board variables
    bool        userIsBoardOwner;
    int         buttonIndexFacebook,
                buttonIndexEmail,
                buttonIndexEdit,
                buttonIndexDelete;
    bool        hasSound[9];
    bool        hasImage[9];
}

// MODE TRANSITIONS GO HERE
// THE FOLLOWING METHODS COVER ENTER AND EXIT MODE FUNCTIONS

// actionButtonPressed calls the Enter to edit function when the user chooses to
// enter edit mode. The user presses "done" to exit edit mode.
-(void)enterEditMode;
-(void)exitEditMode;

// This function is called whenever an audio button is pressed
// In edit mode, this triggers loading the edit dialog for the button.
-(IBAction)buttonPressed:(UIButton *)sender;

// Pressing the action button (right UIBarButtonItem) calls this function.
// Note that if the board is in edit mode, then this could be a "Done" button.
-(IBAction)actionButtonPressed:(UIBarButtonItem *)sender;

// This function is called on the button when the Long Press Gesture Recognizer
// determines that an event has occured on this button.
//-(IBAction)longPress:(UILongPressGestureRecognizer *)sender;

// This function is called when creating a new theme, to trigger the new theme
// create flow.
-(void)newTheme;

// This function loads the theme from disk
-(void)loadTheme:(NSString *)themeName;

//@property (nonatomic, retain) UILongPressGestureRecognizer *longPressGR;
@property (nonatomic, retain) UIBarButtonItem *actionButton;
@property (nonatomic, retain) IBOutlet EditSoundViewController *EditSoundVC;

@end
