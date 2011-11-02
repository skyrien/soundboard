//
//  BoardViewController.m
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 BadHydra Productions. All rights reserved.
//
//  This is the BoardViewController class. It implements functioanltiy described in the
//  project specification OneNote document slide titled "Board View".
//
//  skyrien@gmail.com/2011 > SoundBoard > User Experience Slides > Board View
//

#import "BoardViewController.h"

@implementation BoardViewController
@synthesize actionButton, EditSoundVC;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Board view loaded.");

    // Setting up the board...
    session = [AVAudioSession sharedInstance];
    
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    
    theBoard = [[Soundboard alloc] init];
    themeManager = [[ThemeManager alloc] init];
    mode = MODE_EMPTY;
    buttonIndexFacebook = buttonIndexEmail = buttonIndexEdit = buttonIndexDelete = -1;
//    self.navigationItem.backBarButtonItem.title = @"Home"; 
//    longPressGR.delegate = self;
    
    // Accessor pointers
    navController = self.navigationController;
    
    // The following should only be set if in debug mode
    [self loadTheme:@"debug"];
    userIsBoardOwner = YES;

}

// ACTION SHEET LOGIC

-(void)didPresentActionSheet {
    NSLog(@"Action sheet was presented");
    
}

-(IBAction)actionButtonPressed:(UIButton *)sender {
    NSLog(@"Action button was pressed");
    
    if (mode == MODE_READY)
    {
        // This is the view if the current user is the board's owner
        if (userIsBoardOwner) {
            NSLog(@"Current user is the board's owner. Loading OWNER action sheet.");
            boardActionSheet =
            [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:(id)self
                               cancelButtonTitle:LOC_CANCEL
                          destructiveButtonTitle:nil
                               otherButtonTitles:LOC_SHARE_EMAIL,
                                                 LOC_SHARE_FACEBOOK,
                                                 LOC_EDITBOARD,
                                                 LOC_DELETEBOARD,
                                                 nil, nil];
            // Setting owner action sheet parameters
            boardActionSheet.destructiveButtonIndex = 3;
            buttonIndexEmail = 0;
            buttonIndexFacebook = 1;
            buttonIndexEdit = 2;
            buttonIndexDelete = 3;
            
        }
        
        // This is for non-owners
        else {
            NSLog(@"Current user is the board's owner. Loading VIEWER action sheet.");
            boardActionSheet =
            [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:(id)self
                               cancelButtonTitle:LOC_CANCEL
                          destructiveButtonTitle:nil
                               otherButtonTitles:LOC_SHARE_EMAIL,
                                                 LOC_SHARE_FACEBOOK,
                                                 LOC_DELETEBOARD,
                                                 nil ];
            // Setting viewer action sheet parameters
            boardActionSheet.destructiveButtonIndex = 2;
            buttonIndexEmail = 0;
            buttonIndexFacebook = 1;
            buttonIndexDelete = 2;
            
        }
        [boardActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [boardActionSheet showInView:self.navigationController.view];
        
    }
    
    else if (mode == MODE_EDIT)
    {
        
    }
                   
}

// This message is sent internally when a action sheet button is pressed
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSLog(@"Pressed button at index: %i", buttonIndex);


    // This is the first action sheet
    if (actionSheet == boardActionSheet)
    {        
        // Entering edit mode actually doesn't do anything:
        // Instead, this pops over a dialog showing the user how to edit the button
        if (buttonIndex == buttonIndexEdit) {
            NSLog(@"User pressed \"Edit this board\".");
            [self enterEditMode];
        }
        
        // The user clicked the share to email button.
        else if (buttonIndex == buttonIndexEmail) {
            NSLog(@"User pressed \"Share by Email\".");

            // NEED CODE HERE FOR EMAIL BASED SHARING
            // THE FOLLOWING LOGIC IS REQUIRED
            // 
            // 1. CHECK TO SEE IF BOARD IS UPLOADED TO DROPBOX
            // 2. IF NOT, BEGIN "DROPBOX UPLOAD FLOW"
            // 3. IF UPLOADED, GET PUBLIC-BOARD URL
            // 4. INIT EMAIL INTERFACE, PRELOAD TEMPLATE TEXT
        }

        // The user clicked the share to Facebook button.        
        else if (buttonIndex == buttonIndexFacebook) {
            NSLog(@"User pressed \"Share by Facebook\".");
            
            // NEED CODE HERE FOR FACEBOOK BASED SHARING
            // THE FOLLOWING LOGIC IS REQUIRED
            // 
            // 1. CHECK TO SEE IF BOARD IS UPLOADED TO DROPBOX
            // 2. IF NOT, BEGIN "DROPBOX UPLOAD FLOW"
            // 3. IF UPLOADED, GET PUBLIC-BOARD URL
            // 4. IS USER CONNECTED TO FACEBOOK? IF NOT, BEGIN FB FLOW
            // 5. AFTER CONSENT IS RECEIVED, POST TO FACEBOOK WITH PUBLIC LINK
        }
        
        else if (buttonIndex == buttonIndexDelete) {
            NSLog(@"User pressed \"Delete this board\".");
            
            // Show the delete confirmation (y/n) actionsheet
            confirmDeleteActionSheet =
            [[UIActionSheet alloc] initWithTitle:LOC_CONFIRMDELETE
                                        delegate:(id)self
                               cancelButtonTitle:LOC_CANCEL
                          destructiveButtonTitle:LOC_FINALCONFIRMATION
                               otherButtonTitles:nil, nil];
            [confirmDeleteActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
            [confirmDeleteActionSheet showInView:self.navigationController.view];
        }    
        else {
            NSLog(@"User pressed \"Cancel\".");
        }

    }
    
    // This is the delete confirmation action sheet
    else if (actionSheet == confirmDeleteActionSheet)
    {
        if (buttonIndex == 0) {
            NSLog(@"User pressed \"Yes, delete this board\".");

        }
        else if (buttonIndex == 1)
        {
            NSLog(@"User pressed \"Cancel\".");
        }

    }

    buttonIndexFacebook = buttonIndexEmail = buttonIndexEdit = buttonIndexDelete = -1;
    
}

// MODE TRANSITIONS GO HERE
// THE FOLLOWING METHODS COVER ENTER AND EXIT MODE FUNCTIONS

-(void)enterEditMode {
    
    // Allocation needed elements
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                 target:self
                                 action:@selector(exitEditMode)];
                                   
    
    // Change UI elements as appropriate to indicate mode change.
    navController.navigationBar.tintColor = [UIColor lightGrayColor];
    [self.navigationItem setHidesBackButton:YES animated:YES];
    self.title = [NSString stringWithFormat:@"Editing %@",theBoard.currentTheme];
    [self.navigationItem setRightBarButtonItem:doneButton animated:YES];

    // Preparing the edit view controller so the user can use it
    EditSoundVC = [[EditSoundViewController alloc] initWithNibName:@"EditView" bundle:nil];
    
    // Finally, set the mode
    mode = MODE_EDIT;
    NSLog(@"Entered edit mode. New mode: %i", mode);
}

-(void)exitEditMode {
    // Return UI elements to normal (gray)
    navController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.title = theBoard.currentTheme;
    [self.navigationItem setHidesBackButton:NO animated:YES];
    [self.navigationItem setRightBarButtonItem:actionButton animated:YES];

    // Reload the theme in case there were changes
    [self loadTheme:theBoard.currentTheme];
    
    mode = MODE_READY;
    NSLog(@"Exited edit mode. New mode: %i", mode);
}


// DIRECT USER INTERACTION METHODS ARE COVERED IN THIS SECTION

-(IBAction)buttonPressed:(UIButton *)sender {
    NSString* buttonName = [[sender titleLabel] text];
    NSLog(@"Button %@ was pressed, while in Mode: %i", buttonName, mode);

    // If in ready (play) mode, play the sound
    if (mode == MODE_READY)
    {
        [theBoard playSound:buttonName];
    }
    
    // if in edit mode, bring up the edit dialog
    else if (mode == MODE_EDIT)
    {
        [self presentModalViewController:EditSoundVC animated:YES];
        [EditSoundVC loadSound:[sender.titleLabel text] FromTheme:theBoard.currentTheme];
//        [EditSoundVC loadSound:sender];
//        [self dismissModalViewControllerAnimated:YES];
    }
}

/*
-(IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    UIButton* longPressedButton;
    
    // Since we only care when the gesture began
    if (sender.state == UIGestureRecognizerStateBegan) {
        longPressedButton = sender.view;
        NSLog(@"Button %@ was LONG pressed.", [[longPressedButton titleLabel] text]);
    }
    

}
*/


-(void)loadTheme:(NSString *)themeName {
    
    //Initializes basic theme elements, including name, background, audio, etc...
    theBoard.currentTheme = themeName;
    self.title = themeName;
    
    // SET THE THEME DIR USING THEME MANAGER
    // WARNING, IF THE DIRECTORY DOESN'T EXIST, THIS WILL SILENTLY CREATE IT
    // WE SHOULD PROBABLY RETURN SOMETHING ELSE HERE
    NSError* err = nil;
    [themeManager CreateDirectory:themeName error:&err];
    
    // LOAD THEME METADATA FILE
    err = nil;
    //[themeManager GetFile:@"themeproperties.plist" error:&err];
    
    // VALIDATE THAT THE CURRENT USER IS THE BOARD'S OWNER    
    // IS THIS NECESSARY? WE DON'T REALLY HAVE A CONCEPT OF "CURRENT OWNER"

    // Create an array of the buttons for the for loop
    NSArray *soundButtons = [NSArray arrayWithObjects:
                             button1,
                             button2,
                             button3, 
                             button4,
                             button5,
                             button6,
                             button7,
                             button8,
                             button9, nil];
    
    // NOW, LOAD THE MEDIA FILES
    for (int i = 0; i < 9; i++)
    {
        int j = i + 1;
        NSString* soundFileName = [NSString stringWithFormat:@"sound_%i.caf", j];
        NSString* imageFileName = [NSString stringWithFormat:@"image_%i.png", j];
        
        NSError* err = nil;
        NSURL *newSound = [themeManager GetFile:soundFileName error:&err];
        if (err)
        {
            NSLog(@"Theme Manager: %@ %d %@", [err domain], [err code],
                  [[err userInfo] description]);            
            NSLog(@"Theme Manager failed to get file %@.", soundFileName);
        }
        else
            [theBoard setSoundNumber:j withCFURL:(__bridge CFURLRef)newSound];
            NSLog(@"Theme Manager got file %@ successfully.", soundFileName);
        
        err = nil;
        NSURL *newImage = [themeManager GetFile:imageFileName error:&err];
        if (err)
        {
            NSLog(@"Theme Manager: %@ %d %@", [err domain], [err code],
                  [[err userInfo] description]);            
            NSLog(@"Theme Manager failed to get file %@.", imageFileName);
        }
        else
        {
            NSLog(@"Theme Manager got  file %@ successfully.", imageFileName);
            NSString* imageRelativePath = [newImage relativePath];
            [[soundButtons objectAtIndex:i] setImage:[UIImage imageNamed:imageRelativePath] forState:UIControlStateNormal];
        
        }
        NSLog(@"Initialized soundId %i.", j);
    }
    
    /*
    
    // READ IN MEDIA FROM FILE SYSTEM
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    for (int i = 0; i < 9; i++)
    {
        int j = i + 1;
        NSString* fileName = [NSString stringWithFormat:@"%@_%i", @"sound", j];
        NSString* imageFileName = [NSString stringWithFormat:@"%@_%i.png", @"image", j];
        
        if (j == 1) // else if (i == 1)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("m4a"), NULL)]; 
            [button1 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 2)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("caf"), NULL)];
            [button2 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];            
        }
        else if (j == 3)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)]; 
            [button3 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 4)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)];
            [button4 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 5)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)]; 
            [button5 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 6)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)]; 
            [button6 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 7)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)]; 
            [button7 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 8)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)]; 
            [button8 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 9)
        {
            [theBoard setSoundNumber:j withCFURL:CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL)]; 
            [button9 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        
        NSLog(@"Initialized soundId %i.", j);
        
    }
     */
    
    mode = MODE_READY;
    NSLog(@"Finished loading \"%@\" theme", themeName);
}


// Initialization, view management functionality lies below

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
