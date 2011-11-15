//
//  NewBoardPrompt.m
//  Soundboard
//
//  Created by Ibrahim Shareef on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewBoardPrompt.h"

@implementation NewBoardPrompt

@synthesize boardNameText;
@synthesize enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
	if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
	{
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)]; 
		[textField setBackgroundColor:[UIColor whiteColor]]; 
		[self addSubview:textField];
		self.boardNameText = textField;
		CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 70.0); 
		[self setTransform:translate];
	}
	return self;
}


- (void)show
{
	[boardNameText becomeFirstResponder];
	[super show];
}


- (NSString *)enteredText
{
	return boardNameText.text;
}

@end

