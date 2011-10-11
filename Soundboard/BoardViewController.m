//
//  BoardViewController.m
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BoardViewController.h"

@implementation BoardViewController

// BOARD LOGIC GOES HERE
-(IBAction)buttonPressed:(UIButton *)sender {

    NSString* buttonName = [[sender titleLabel] text];
    NSLog(@"Button \"%@\" was pressed.", buttonName);

    // Sound gets played here
    [self playSound:buttonName];
}


-(void)playSound:(NSString *)buttonName {
    int i = [buttonName integerValue];
    AudioServicesPlaySystemSound(soundIds[i-1]);
    
}


-(void)loadTheme:(NSString *)themeName {
    
    //Initializes basic theme elements, including name, background, audio, etc...
    currentTheme = themeName;
    
    // READ IN FROM FILE SYSTEM
    for (int i = 0; i < 9; i++)
    {
        NSString* fileName = [NSString stringWithFormat:@"%@_%i", currentTheme, i];
        NSString* imageFileName = [NSString stringWithFormat:@"%@_%i.png", currentTheme, i];
        CFBundleRef mainBundle = CFBundleGetMainBundle();
        CFURLRef soundFileURLRef;
        
        // Special casing for these debug files
        if      (i == 0)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("m4a"), NULL);
            [button0 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 1)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("m4a"), NULL);
            [button1 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 2)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("caf"), NULL);
            [button2 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];            
        }
        else if (i == 3)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button3 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 4)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button4 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 5)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button5 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 6)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button6 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 7)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button7 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 8)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button8 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (i == 9)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button9 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundIds[i]);
        NSLog(@"Initialized soundId %i.", i);
        
    }
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Board view loaded.");
    [self loadTheme:@"debug"];
}


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

@synthesize button1, button2, button3, button4, button5,
            button6, button7, button8, button9, button0;

@end
