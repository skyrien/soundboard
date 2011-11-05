//
//  HomeViewController.m
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <DBLoginControllerDelegate, DBRestClientDelegate> 

-(void) updateButtons;

@property (nonatomic, readonly) DBRestClient* restClient;

@end




@implementation HomeViewController

- (IBAction)buttonPressed:(UIButton *)sender
{
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
}

-(void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    NSLog(@"successfully loaded file %s", [destPath UTF8String]);
    
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSError* err = nil;
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    if (err != nil)
    {
        //TODO: Some bad shit happened....code more graceful error handling later
        NSLog(@"URLForDirectory Method in loadedFile callback returned error!");
    }
    
    //TODO: Obtain current board name from Soundboard class?? hardcoded for now
    NSString* currBoardDir = [[suppurl path] stringByAppendingPathComponent:@"Test"];
    //verify that the file was actually downloaded
    if (![fm fileExistsAtPath:[[suppurl path] stringByAppendingPathComponent:@"debug_8.png"]])
    {
        NSLog(@"debug_8.png was not downloaded!!! NOOOOO!!!!");
    }
    else
    {
        NSLog(@"debug_8.png was downloaded!!! Yayyyy!!!");
    }
}

- (void)loginControllerDidLogin:(DBLoginController*)controller {
    [self updateButtons];
    
    //download the board
    //TODO: initialization failure? Exception thrown? Close the app on error?
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSError* err = nil;
    NSURL* suppurl = [fm URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err];
    if (err != nil)
    {
        //TODO: Some bad shit happened....code more graceful error handling later
        NSLog(@"URLForDirectory Method called returned error!");
    }
    
    //TODO: Obtain current board name from Soundboard class?? hardcoded for now
    NSString* currBoardDir = [[suppurl path] stringByAppendingPathComponent:@"Test"];
    
    if (![fm fileExistsAtPath:currBoardDir])
    {
        //create the directory
        NSError* err = nil;
        [fm createDirectoryAtPath:currBoardDir withIntermediateDirectories:NO attributes:nil error:&err];
        if (err != nil)
        {
            //TODO: Handle error...catastrophic failure?
            NSLog(@"Create Directory failed!!");
        }
    }
    //Now we should have a directory (barring errors) in the docs space for the app, download a file into it
    //TODO: Check if current directory exists in dropbox folder. For now, assume that it does
    NSString* tmploc = [[suppurl path] stringByAppendingPathComponent:@"debug_8.png"];
    [self.restClient loadFile:@"/Public/Test/debug_8.png" intoPath:tmploc];
    
}

- (void)updateButtons
{
    NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
    [linkButton setTitle:title forState:UIControlStateNormal];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    NSLog(@"Home view loaded.");
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

@end
