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
    self = [super init];
    return self;
}


-(void)enterEditMode {
    
}

-(void)setSoundNumber:(int)buttonNumber withCFURL:(CFURLRef)theURL {
    
    AudioServicesCreateSystemSoundID(theURL, &soundIds[buttonNumber - 1]);
    
}


-(void)playSound:(NSString *)buttonName {
    int i = [buttonName integerValue];
    AudioServicesPlaySystemSound(soundIds[i-1]);
    
}


@synthesize button1, button2, button3, button4, button5,
button6, button7, button8, button9, boardOwnerId, currentTheme;

@end
