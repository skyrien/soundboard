//
//  BoardViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardViewController : UIViewController
{
    // Collection of buttons in IB
    IBOutlet UIButton* button1;
    IBOutlet UIButton* button2;    
    IBOutlet UIButton* button3;
    IBOutlet UIButton* button4;
    IBOutlet UIButton* button5;
    IBOutlet UIButton* button6;
    IBOutlet UIButton* button7;
    IBOutlet UIButton* button8;
    IBOutlet UIButton* button9;
    IBOutlet UIImageView* background;

    // Other theme Properties
    NSString* currentTheme;
}

// This function is called whenever a button is pressed
-(IBAction)buttonPressed:(UIButton *)sender;

// This function attempts to play the audio file corresponding to the button
-(void)playSound:(NSString *)buttonName;

-(void)loadTheme:(NSString *)themeName;

//@property(nonatomic) NSString* currentTheme;

@end
