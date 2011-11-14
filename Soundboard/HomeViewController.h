//
//  HomeViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropBoxModule.h"


@interface HomeViewController : UIViewController
{
    DBRestClient* restClient;
    NSArray* themes;
    UIActionSheet* addActionSheet;
}

@property (retain) NSArray* themes;
-(IBAction)buttonPressed:(UIButton* )sender;

@end
