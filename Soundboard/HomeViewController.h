//
//  HomeViewController.h
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"


@interface HomeViewController : UIViewController
{
    IBOutlet UIButton* linkButton;
    
    DBRestClient* restClient;
}

-(IBAction)buttonPressed:(UIButton* )sender;

@end
