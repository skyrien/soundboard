//
//  HomeViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface HomeViewController : UIViewController
{
    IBOutlet UIButton* linkButton;
}

-(IBAction)buttonPressed:(UIButton* )sender;

@end