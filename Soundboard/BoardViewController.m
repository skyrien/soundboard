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
@synthesize longPressGR;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Board view loaded.");
    self.navigationController.navigationBar.backItem.leftBarButtonItem.title = @"Home";

    // Setting up the board...
    theBoard = [[Soundboard alloc] init];
    theBoard.boardMode = MODE_EMPTY;
    buttonIndexFacebook = buttonIndexEmail = buttonIndexEdit = buttonIndexDelete = -1;
    longPressGR.delegate = self;
    
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
    
    if (theBoard.boardMode == MODE_READY)
    {
        // This is the view if the current user is the board's owner
        if (userIsBoardOwner) {
            NSLog(@"Current user is the board's owner. Loading owner action sheet.");
            boardActionSheet = [[UIActionSheet alloc]  initWithTitle:nil
                                                            delegate:self
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
            NSLog(@"Current user is the board's owner. Loading viewer action sheet.");
            boardActionSheet = [[UIActionSheet alloc]  initWithTitle:nil
                                                            delegate:self
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
    
    else if (theBoard.boardMode == MODE_EDIT)
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
            NSLog(@"Entering board edit mode...");
            
        }
        else if (buttonIndex == buttonIndexEmail) {
            NSLog(@"Entering sharing email mode...");
        }
        
        else if (buttonIndex == buttonIndexFacebook) {
            NSLog(@"Entering Facebook sharing mode...");
        }
        else if (buttonIndex == buttonIndexDelete) {
            NSLog(@"Showing board delete confirmation...");
            confirmDeleteActionSheet = [[UIActionSheet alloc] initWithTitle:LOC_CONFIRMDELETE
                                                                   delegate:self
                                                          cancelButtonTitle:LOC_CANCEL
                                                     destructiveButtonTitle:LOC_FINALCONFIRMATION
                                                          otherButtonTitles:nil, nil];
            [confirmDeleteActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
            [confirmDeleteActionSheet showInView:self.navigationController.view];
        }    
        else {
            NSLog(@"User canceled board action.");
        }

    }
    
    // This is the delete confirmation action sheet
    else if (actionSheet == confirmDeleteActionSheet)
    {
        if (buttonIndex == 0) {
            NSLog(@"Entering board delete mode...");

        }
        else if (buttonIndex == 1)
        {
            NSLog(@"User canceled delete operation.");
        }

    }

    
}
/*
// This message is sent internally when a action sheet button is pressed
- (void)actionSheet:confirmDeleteActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}
*/

// PLAYBACK FUNCTIONS GO HERE

-(IBAction)buttonPressed:(UIButton *)sender {
    NSString* buttonName = [[sender titleLabel] text];
    NSLog(@"Button %@ was pressed.", buttonName);

    // If in ready (play) mode, play the sound
    if (theBoard.boardMode == MODE_READY)
    {

        // Sound gets played here
        [theBoard playSound:buttonName];
    }
    
    // if in edit mode, bring up the edit dialog
    else if (theBoard.boardMode == MODE_EDIT)
    {
        
    }
}

-(IBAction)longPress:(UILongPressGestureRecognizer *)sender {
    NSLog(@"Button %@ was LONG pressed.",  sender);
}

-(void)loadTheme:(NSString *)themeName {
    
    //Initializes basic theme elements, including name, background, audio, etc...
    theBoard.currentTheme = themeName;
    self.title = themeName;
    
    // VALIDATE THAT THE CURRENT USER IS THE BOARD'S OWNER
    

    CFBundleRef mainBundle = CFBundleGetMainBundle();

    // READ IN MEDIA FROM FILE SYSTEM
    for (int i = 0; i < 9; i++)
    {
        int j = i + 1;
        NSString* fileName = [NSString stringWithFormat:@"%@_%i", themeName, j];
        NSString* imageFileName = [NSString stringWithFormat:@"%@_%i.png", themeName, j];
        
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
    theBoard.boardMode = MODE_READY;
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
