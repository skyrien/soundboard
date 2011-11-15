//
//  HomeViewController.m
//  Soundboard
//
//  Created by Alexander Joo on 10/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "DropBoxModule.h"
#import "LocStrings.h"
#import "BoardViewController.h"
#import "NewBoardPrompt.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource> 

-(void) updateButtons;
-(void)displayNewBoardPrompt;
-(NSArray*) GetThemeDisplayTextFromThemeDirName:(NSString*)themeDirName;

@property (nonatomic, readonly) DBRestClient* restClient;

@end


@implementation HomeViewController

@synthesize tableView;

-(NSArray*) themes
{
    /*if (nil == self->themes)
    {
        //@TODO: Handle errors during themeloading
        self->themes = [ThemeManager GetLocalThemes:nil];
    }
    return self->themes;*/
    return  [ThemeManager GetLocalThemes:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    NSLog(@"Returned 1 as the number of sections");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"Found the following number of rows: %d", [self.themes count]);
    return [self.themes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ThemeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSLog(@"Set the following text for cell at %d. text: %@", indexPath.row, [self.themes objectAtIndex:indexPath.row]);
    NSString* filename = [[self.themes objectAtIndex:indexPath.row] lastPathComponent];
    cell.textLabel.text = filename;
    //@TODO: This needs to be set based on value stored in the directory name
    cell.detailTextLabel.text = @"Author: Ibrahim Shareef";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     /*BoardViewController *boardViewController = [[BoardViewController alloc] initWithNibName:nil bundle:nil];*/
    BoardViewController* boardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
    
    //[self performSegueWithIdentifier:@"BoardViewController" sender:self];
     // ...
     // Pass the selected object to the new view controller.
    NSString* themeName = [[self.themes objectAtIndex:indexPath.row] lastPathComponent];
    NSLog(@"Row was selected at %@", themeName);
    
    [self.navigationController pushViewController:boardViewController animated:YES];
    [boardViewController loadTheme:themeName]; 
     
}


/*
 *@TODO: This needs to parse the theme directory name and return the strings to display on 
 the cell
 **/
-(NSArray*) GetThemeDisplayTextFromThemeDirName:(NSString *)themeDirName
{
    
}

-(IBAction) addButtonPressed:(UIButton *)sender
{
    addActionSheet =
    [[UIActionSheet alloc] initWithTitle:nil
                                delegate:(id)self
                       cancelButtonTitle:LOC_CANCEL
                  destructiveButtonTitle:nil
                       otherButtonTitles:LOC_Create_NEW_BOARD,
                                         LOC_BROWSE_BOARDS,
                                         nil, nil];
    [addActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [addActionSheet showInView:self.navigationController.view];
    
}

-(void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == as.cancelButtonIndex)
    {
        return;
    }
    else if (buttonIndex == 0) //Create new board...
    {
        [self displayNewBoardPrompt];
    }
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		NSString *entered = [(NewBoardPrompt *)alertView enteredText];
        //@TODO: verify that the boardname does not contain special characters, like -,@,#, etc. since these are used in the formatting of directory names
		if (nil != entered && [entered length] != 0)
        {
                BoardViewController* boardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardViewController"];
            [self.navigationController pushViewController:boardViewController animated:YES];
            [boardViewController loadTheme:entered];
        }
	}
}


-(void)displayNewBoardPrompt
{
    NewBoardPrompt *prompt = [NewBoardPrompt alloc];
    prompt = [prompt initWithTitle:@"Enter Board Name" message:@"Please Enter Board Name" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
    [prompt show];
}

- (IBAction)buttonPressed:(UIButton *)sender
{
    /*DropBoxModule* dbmod = [[DropBoxModule alloc] initWithThemeName:@"debug"];
    [dbmod uploadTheme];*/
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
    //NSString* title = [[DBSession sharedSession] isLinked] ? @"Unlink Dropbox" : @"Link Dropbox";
    //[linkButton setTitle:title forState:UIControlStateNormal];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Home view loaded.");
    self.title = @"Main Menu";
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
