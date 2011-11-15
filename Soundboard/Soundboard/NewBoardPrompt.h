//
//  NewBoardPrompt.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewBoardPrompt : UIAlertView
{
    UITextField* boardNameText;
}

@property (retain) UITextField* boardNameText;
@property (retain) NSString* enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end
