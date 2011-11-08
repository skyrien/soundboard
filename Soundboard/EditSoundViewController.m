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
    
    // INITIALIZING SHARED PROPERTIES
    themeManager = [[ThemeManager alloc] init];
    fileManager = [[NSFileManager alloc] init];
    playTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0/PLAY_TIMER_UPDATE_RATE)
                                                 target:self
                                               selector:@selector(updatePlayTimer)
                                               userInfo:nil
                                                repeats:YES];
    tickNumber = 0;
    isPlaying = NO;
    
    // Setting up directory parameters
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"tempsound.caf"];
    tempSound = [NSURL fileURLWithPath:soundFilePath];    
    
    // Configuring the audio session
    session = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [session setActive:YES error:&err];
    if (err)
        NSLog(@"Audio session: %@ %d %@", [err domain], [err code],
                                        [[err userInfo] description]);
    
    // The following configures the audio format to what we need for SoundBoard
    NSDictionary *recordSetting = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    err = nil;
    theRecorder = [[AVAudioRecorder alloc] initWithURL:tempSound 
                                              settings:recordSetting 
                                                 error:&err];
    if (err)
        NSLog(@"Audio Recorder: %@ %d %@", [err domain], [err code],
                                        [[err userInfo] description]);
    
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

- (void)loadSound:(NSString*) soundNumber FromTheme:(NSString*)themeName {
    // Declare/init vars
    if (!soundId)
        AudioServicesDisposeSystemSoundID(soundId);
    NSURL *soundUrl, *imageUrl;
    currentSoundNumber = soundNumber;
    currentThemeName = themeName;
    navigationItem.title = [NSString stringWithFormat:@"Editing Tile %@", soundNumber];
    NSError *themeManagerError = nil;
    [themeManager CreateDirectory:themeName error:&themeManagerError];
    if (themeManagerError)
        NSLog(@"Theme Manager: %@ %d %@", [themeManagerError domain], [themeManagerError code],
              [[themeManagerError userInfo] description]);
    
    NSLog(@"Loading Sound %@ properties for editing.", soundNumber);
    
    NSString* fileName = [NSString stringWithFormat:@"sound_%@.caf", currentSoundNumber];
    NSString* imageFileName = [NSString stringWithFormat:@"image_%@.png", currentSoundNumber];
    
    // LOAD THE SOUND
    themeManagerError = nil;
    soundUrl = [themeManager GetFile:fileName error:&themeManagerError];
    if (themeManagerError)
        NSLog(@"Theme Manager: %@ %d %@", [themeManagerError domain], [themeManagerError code],
              [[themeManagerError userInfo] description]);
    else
    {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundId);   
        NSLog(@"Sound %@ loaded successfully.", soundNumber);
    }    
    
    // LOAD THE IMAGE
    themeManagerError = nil;
    imageUrl = [themeManager GetFile:imageFileName error:&themeManagerError];
    if (themeManagerError)
        NSLog(@"Theme Manager: %@ %d %@", [themeManagerError domain], [themeManagerError code],
              [[themeManagerError userInfo] description]);
    else
    {
        NSString *imagePath = [imageUrl path];
        NSLog(@"Image %@ loaded successfully.", soundNumber);
        [soundTileButton setImage:[UIImage imageWithContentsOfFile:imagePath]
                         forState:UIControlStateNormal];
    }
    mode = MODE_READY;
}

- (int)updatePlayTimer {
    
    // COUNTING UP WHILE RECORDING
    if (theRecorder.isRecording)
        tickNumber++;
    // COUNTING UP WHILE PLAYING
    else if (isPlaying && ([maxTime.text floatValue] > [currentTime.text floatValue])) {
        tickNumber++;
        currentTime.text = [NSString stringWithFormat:@"%f", ((float)tickNumber/PLAY_TIMER_UPDATE_RATE)];
        [progressBar setProgress:([currentTime.text floatValue]/[maxTime.text floatValue]) animated:NO];
    }

    // STOPPED
    else if (isPlaying) {
        isPlaying = NO;
    }
    return tickNumber;
}

-(IBAction)doneEditing:(UIBarButtonItem *) sender {
    NSLog(@"User pressed done.");
    
    if ((mode == MODE_READYWITHNEWSOUND) ||
        (mode == MODE_RECORDING) ||
        (mode == MODE_RECORDINGPAUSED))
    {
        // Stop recording if it's going on
        if (theRecorder.isRecording)
            [theRecorder stop];
        
        // BS for generating new path
        NSArray *dirPaths;
        NSString *docsDir;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *newFileName = [NSString stringWithFormat:@"sound_%@.caf", currentSoundNumber];
        NSString *newFilePath = [docsDir
                                 stringByAppendingPathComponent:newFileName];
        NSURL* finalUrl = [NSURL fileURLWithPath:newFilePath];
        //NSFileManager* fileManager = [[NSFileManager alloc] init];
        NSError *themeManagerError = nil;
        
        // Deletes target then renames temp file to target file name
        [fileManager removeItemAtURL:finalUrl error:&themeManagerError];
        if (themeManagerError)
            NSLog(@"Theme Manager: %@ %d %@", [themeManagerError domain], [themeManagerError code],
                  [[themeManagerError userInfo] description]);
        else
            NSLog(@"Target file \"%@\" was taken, so it was deleted.", newFileName);
        
        // Rename...
        themeManagerError = nil;
        [fileManager moveItemAtURL:tempSound toURL:finalUrl error:&themeManagerError];
        if (themeManagerError)
            NSLog(@"Theme Manager: %@ %d %@", [themeManagerError domain], [themeManagerError code],
                  [[themeManagerError userInfo] description]);
        else
        {
            NSLog(@"File rename successful. Now %@", newFileName);
            
            // Adds file using the theme manager
            themeManagerError = nil;
            //CFURLRef newCFURL = (__bridge CFURLRef)finalUrl;
            [themeManager CreateDirectory:currentThemeName error:nil];
            [themeManager AddFile: finalUrl error:&themeManagerError];
            if (themeManagerError)
            {
                NSLog(@"Theme Manager: %@ %d %@", [themeManagerError domain], [themeManagerError code],
                      [[themeManagerError userInfo] description]);            
                NSLog(@"Theme Manager failed to add file %@.", newFileName);
            }
            else
                NSLog(@"Theme Manager added file %@ successfully.", newFileName);
        }
        
        // De-allocating anything that was created
        AudioServicesDisposeSystemSoundID(soundId);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)cancelEditing:(UIBarButtonItem *) sender {
    NSLog(@"User pressed cancel.");

    // IF THERE WAS A TEMP FILE, DELETE IT
    if (mode == MODE_READYWITHNEWSOUND)
    {
        NSError *err = nil;
        [fileManager removeItemAtURL:tempSound error:&err];
        if (err)
            NSLog(@"Theme Manager: %@ %d %@", [err domain], [err code],
                  [[err userInfo] description]);
        else
            NSLog(@"Recording left a temp file. Cleaning up...");
   
    }    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)pressedPlayButton:(UIButton *) sender {
//    NSLog(@"User pressed Play.");
    
    if (mode == MODE_READY) {
        NSLog(@"Playing existing sound.");
        AudioServicesPlaySystemSound(soundId); 
    }

    // This plays the new sound if there is one
    else if (mode == MODE_READYWITHNEWSOUND) {
        NSLog(@"Playing new sound.");
        tickNumber = 0;
        currentTime.text = 0;
        [progressBar setProgress:0 animated:NO];
        isPlaying = YES;
        AudioServicesPlaySystemSound(soundId);
    }    
    
    // Pressing this ends the recording and sets the new sound to play when
    // Play is pressed
    else if (theRecorder.recording) {
        [theRecorder stop];
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        maxTime.text = [NSString stringWithFormat:@"%f", (float)tickNumber/PLAY_TIMER_UPDATE_RATE];
        tickNumber = 0;
        [progressBar setProgress:0 animated:NO];
        isPlaying = NO;
        currentTime.text = @"0.0";
        NSLog(@"Recording stopped. New sound saved to temp file.");
        
        // This is supposed to set the new sound to the soundId
        CFURLRef tempSoundUrl = (__bridge CFURLRef)tempSound;
        AudioServicesDisposeSystemSoundID(soundId);
        AudioServicesCreateSystemSoundID(tempSoundUrl, &soundId);
        
        [playButton titleLabel].text = @"Play";
        mode = MODE_READYWITHNEWSOUND;
    }
}

- (IBAction)pressedRecordButton:(UIButton *) sender {
    NSLog(@"User pressed Record.");

    // If recording is already happening, then pause it
    if (theRecorder.recording) {
        
        // Pauses the recording
        [theRecorder pause];
        mode = MODE_RECORDINGPAUSED;
        [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        [[recordButton titleLabel] setText:@"Resume"];
        NSLog(@"Pausing recording...");
    }

    // Otherwise, begin a new recording!
    else {

        // Prepares the scene for recording
        tickNumber = 0;
        currentTime.text = 0;
        mode = MODE_RECORDING;
        [session setCategory:AVAudioSessionCategoryRecord error:nil];
        
        // Starts recording
        NSLog(@"Beginning/Continuing recording...");
        [theRecorder record];
        [[recordButton titleLabel] setText:@"Pause"];
        [[playButton titleLabel] setText:@"Stop"];
        
    }
    

}

- (IBAction)pressedDeleteButton:(UIButton *) sender {
    NSLog(@"User pressed Delete.");

    confirmDeleteActionSheet = [[UIActionSheet alloc] initWithTitle:LOC_CONFIRMDELSOUND
                                                           delegate:(id)self
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
        NSString *newFileName = [NSString stringWithFormat:@"sound_%@.caf", currentSoundNumber];

        NSError *err = nil;
        [themeManager DeleteFile:newFileName error:&err];
        if (err)
            NSLog(@"Theme Manager: %@ %d %@", [err domain], [err code],
                  [[err userInfo] description]);
        else {
            NSLog(@"Deleted file \"%@\" from theme.", newFileName);
        }
        err = nil;
        [fileManager removeItemAtURL:tempSound error:&err];
        if (err)
            NSLog(@"FileManager: %@ %d %@", [err domain], [err code],
                  [[err userInfo] description]);
        else {
            NSLog(@"Deleted temporary file.");
        }
        
        // And since the sound is now gone, go back to the board view
        [self dismissModalViewControllerAnimated:YES];
    }
    
}
    

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
    
    NSLog (@"Audio recorder finished successfully.");
}


@end
