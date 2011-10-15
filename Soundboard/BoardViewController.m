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

    theBoard = [[Soundboard alloc] initWithTheme:@"debug"];
    
    // Assigning IBPointers to buttons
    button1 = theBoard.button1;
    button2 = theBoard.button2;
    button1 = theBoard.button3;
    button1 = theBoard.button4;
    button1 = theBoard.button5;
    button1 = theBoard.button6;
    button1 = theBoard.button7;
    button1 = theBoard.button8;
    button1 = theBoard.button9;
    
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
