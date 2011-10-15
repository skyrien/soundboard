//
//  Soundboard.m
//  
//
//  Created by Alexander Joo on 10/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Soundboard.h"

@implementation Soundboard

-(id)init {
    // Sets current parameters


}

-(id)initWithTheme:(NSString *)themeName {
    
    //Initializes basic theme elements, including name, background, audio, etc...
    currentTheme = themeName;
    
    // VALIDATE THAT THE CURRENT USER IS THE BOARD'S OWNER
    
    userIsBoardOwner = true; // currently hardcoded to true
    
    // READ IN MEDIA FROM FILE SYSTEM
    for (int i = 0; i < 9; i++)
    {
        int j = i + 1;
        NSString* fileName = [NSString stringWithFormat:@"%@_%i", currentTheme, j];
        NSString* imageFileName = [NSString stringWithFormat:@"%@_%i.png", currentTheme, j];
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
            [button1 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 2)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("caf"), NULL);
            [button2 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];            
        }
        else if (j == 3)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button3 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 4)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button4 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 5)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button5 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 6)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button6 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 7)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button7 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 8)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button8 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        else if (j == 9)
        {
            soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("wav"), NULL);
            [button9 setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
        }
        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundIds[i]);
        NSLog(@"Initialized soundId %i.", j);
        
    }
    boardMode = MODE_READY;
    NSLog(@"Finished loading \"%@\" theme", themeName);
    return self;
}


-(void)enterEditMode {
    
}



-(void)playSound:(NSString *)buttonName {
    int i = [buttonName integerValue];
    AudioServicesPlaySystemSound(soundIds[i-1]);
    
}


@synthesize button1, button2, button3, button4, button5,
button6, button7, button8, button9, boardOwnerId;

@end
