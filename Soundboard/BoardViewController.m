//
//  BoardViewController.m
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"

@implementation BoardViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Board view loaded.");
    self.navigationController.navigationBar.backItem.leftBarButtonItem.title = @"Home";

    // Setting up the board...
    theBoard = [[Soundboard alloc] init];

    // The following should only be set if in debug mode
    [self loadTheme:@"debug"];
    userIsBoardOwner = YES;
}

// BOARD LOGIC GOES HERE
-(IBAction)actionButtonPressed:(UIButton *)sender {
    NSLog(@"Action button was pressed");
    
    // This is the view if the current user is the board's owner
    if (userIsBoardOwner) {
        
        boardActionSheet = [[UIActionSheet alloc]  initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:LOC_CANCEL
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:LOC_EDITBOARD,
                                                            LOC_SHARE_EMAIL,
                                                            LOC_SHARE_FACEBOOK,
                                                            LOC_DELETEBOARD,
                                                            nil, nil];
    }
    
    // This is for non-owners
    else {
        boardActionSheet = [[UIActionSheet alloc]  initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:LOC_CANCEL
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:LOC_SHARE_EMAIL,
                                                            LOC_SHARE_FACEBOOK,
                                                            LOC_DELETEBOARD,
                                                            nil, nil];
    }
    [boardActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [boardActionSheet showInView:self.navigationController.view];
                   
}

// This message is sent internally when a action sheet button is pressed
- (void)actionSheet:boardActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Clicked action sheet button index: %i", buttonIndex);
    
    if (buttonIndex == 0)
    [theBoard enterEditMode];
}


-(IBAction)buttonPressed:(UIButton *)sender {

    NSString* buttonName = [[sender titleLabel] text];
    NSLog(@"Button %@ was pressed.", buttonName);

    // Sound gets played here
    [theBoard playSound:buttonName];
}





-(void)longPress:(NSString *)buttonName {
    NSLog(@"Button %@ was LONG pressed.", buttonName);
}

-(void)loadTheme:(NSString *)themeName {
    
    //Initializes basic theme elements, including name, background, audio, etc...
    theBoard.currentTheme = themeName;
    
    // VALIDATE THAT THE CURRENT USER IS THE BOARD'S OWNER
    
    
    // READ IN MEDIA FROM FILE SYSTEM
    for (int i = 0; i < 9; i++)
    {
        int j = i + 1;
        NSString* fileName = [NSString stringWithFormat:@"%@_%i", themeName, j];
        NSString* imageFileName = [NSString stringWithFormat:@"%@_%i.png", themeName, j];
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef soundFileURLRef;
        
        // Special casing for these debug files
        // if      (i == 0)
        //{
        //    soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("m4a"), NULL);
        //   [button0 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        //} 
        if (j == 1) // else if (i == 1)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("m4a"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button1 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 2)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("caf"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button2 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];            
        }
        else if (j == 3)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button3 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 4)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button4 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 5)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button5 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 6)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button6 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 7)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button7 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 8)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button8 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 9)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [theBoard setSoundNumber:j withCFURL:soundFileURLRef]; 
            [button9 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }

        NSLog(@"Initialized soundId %i.", j);
        
    }
//    theBoard.boardMode = MODE_READY;
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
