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
    //NSArray* themes;
    IBOutlet UITableView* tableView;
    UIActionSheet* addActionSheet;
}

@property (retain) NSArray* themes;
@property (retain) UITableView* tableView;
-(IBAction)buttonPressed:(UIButton* )sender;

@end
