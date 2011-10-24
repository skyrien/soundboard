//
//  EditSoundViewController.m
//  Soundboard
//
//  Created by Alexander Joo on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EditSoundViewController.h"

@implementation EditSoundViewController


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
    mode = MODE_EMPTY;
    soundId = 0;
    session = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [session setActive:YES error:&err];
    if (err)
        NSLog(@"Audio session: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    
    // Prepares a temp object to store new recordings
    tempSound = [NSURL fileURLWithPath:@"tempsound.caf"]; 

    // The following configures the audio format to what we need for SoundBoard
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];

    err = nil;
    theRecorder = [[AVAudioRecorder alloc] initWithURL:tempSound settings:recordSetting error:&err];
    if (err)
        NSLog(@"Audio Recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
    
    [theRecorder setDelegate:(id)self];
    [theRecorder prepareToRecord];
    
    // This fires an alert view if the audio hardware is unavailable.
    if (!session.inputIsAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        NSLog(@"Audio hardware failed to load.");
    }
    
    NSLog(@"Edit sound view loaded.");
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

- (void)loadSound:(UIButton *)sender {
    CFURLRef theURL;
    currentSoundNumber = [[sender titleLabel] text];
    self.title = [NSString stringWithFormat:@"Editing Tile %@", currentSoundNumber];
    NSLog(@"Loading Sound %@ properties for editing.", currentSoundNumber);
    
    // Generate a CFURL for the soundbutton
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    NSString* fileName = [NSString stringWithFormat:@"sound_%@", currentSoundNumber];
    NSString* imageFileName = [NSString stringWithFormat:@"image_%@.png", currentSoundNumber];    
    
    theURL = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)fileName, CFSTR ("caf"), NULL); 
    [soundTileButton setImage:[UIImage imageNamed:imageFileName] forState:UIControlStateNormal];
    
    // This finally sets the current sound to the soundId pointer
    AudioServicesCreateSystemSoundID(theURL, &soundId);
    mode = MODE_READY;
    
}


-(IBAction)doneEditing:(UIBarButtonItem *) sender {
    NSLog(@"User pressed done.");
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)cancelEditing:(UIBarButtonItem *) sender {
    NSLog(@"User pressed cancel.");
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)pressedPlayButton:(UIButton *) sender {
    NSLog(@"User pressed Play.");
    
    if (mode == MODE_READY) {
        NSLog(@"Playing existing sound.");
        AudioServicesPlaySystemSound(soundId); 
    }

    // Pressing this ends the recording and sets the new sound to play when
    // Play is pressed
    else if ((mode == MODE_RECORDING) || (mode == MODE_RECORDINGPAUSED)) {
        [theRecorder stop];
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        NSLog(@"Recording stopped. New sound saved to temp file.");
        
        /* THE FOLLOWING WAS RECOMMENDED, BUT SEEMS TO NOT WORK
        NSError *err = nil;
        NSData *audioData = [NSData dataWithContentsOfFile:[tempSound path] options:0 error:&err];
        if (!audioData)
            NSLog(@"Audio session: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        */
        
        // This is supposed to set the new sound to the soundId
        CFURLRef tempSoundUrl = (__bridge CFURLRef)tempSound;
        AudioServicesCreateSystemSoundID(tempSoundUrl, &newSoundId);
        
        [playButton titleLabel].text = @"Play";
        mode = MODE_READYWITHNEWSOUND;
    }

    // This plays the new sound if there is one
    else if (mode == MODE_READYWITHNEWSOUND) {
        NSLog(@"Playing new sound.");
        AudioServicesPlaySystemSound(newSoundId);
    }
}

- (IBAction)pressedRecordButton:(UIButton *) sender {
    NSLog(@"User pressed Record.");

    // If recording is already happening, then pause it
    if (mode == MODE_RECORDING) {
        
        // Pauses the recording
        [theRecorder pause];
        mode = MODE_RECORDINGPAUSED;
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        NSLog(@"Pausing the recording...");
    }

    // Otherwise, begin a new recording!
    else {

        // Prepares the scene for recording
        mode = MODE_RECORDING;
        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        
        // Starts recording
        NSLog(@"Beginning the recording...");
        [theRecorder record];
        [[recordButton titleLabel] setText:@"Pause"];
        [[playButton titleLabel] setText:@"Stop"];
        
    }
    

}

- (IBAction)pressedDeleteButton:(UIButton *) sender {
    NSLog(@"User pressed Delete.");

    confirmDeleteActionSheet = [[UIActionSheet alloc] initWithTitle:LOC_CONFIRMDELSOUND
                                                           delegate:self
                                                  cancelButtonTitle:LOC_CANCEL
                                             destructiveButtonTitle:LOC_FINALCONFIRMDELSOUND
                                                  otherButtonTitles:nil, nil];
    [confirmDeleteActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [confirmDeleteActionSheet showInView:self.view];
    
}

- (IBAction)pressedSoundTileButton:(UIButton *) sender {
    NSLog(@"User pressed SoundTile.");    
}

// This message is sent internally when
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    // User clicked yes
    if (buttonIndex == 0) {
        NSLog(@"Begin to delete sound");   
        
        // CODE TO DELETE SOUND
        // CODE CODE CODE
        
        // And since the sound is now gone, go back to the board view
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
    

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"Audio recorder finished successfully.");
}


@end
