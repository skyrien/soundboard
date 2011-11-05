//
//  DropBoxModule.m
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DropBoxModule.h"


NSString* DBRoot = @"/Public/Soundboard/";


@interface DropBoxModule() <DBLoginControllerDelegate, DBRestClientDelegate, DBSessionDelegate>
{
    NSString* themeName;
    UIViewController* controller;
}

-(void) uploadFiles;
-(void) updateButtons;
-(void) initializeDropBoxModule;
-(void) downloadFiles;

@property (nonatomic, readonly) DBRestClient* restClient;
@property (atomic, assign) NSMutableArray* filesToDownload;
@property (atomic, assign) NSMutableArray* filesToUpload;

@end

@implementation DropBoxModule

@synthesize filesToDownload, filesToUpload;

-(id)initWithThemeName:(NSString *)themeName controller:(UIViewController*)controller
{
    self =[super init];
    if (self)
    {
        //set the shared session, if it already has not been done
        if (nil == [DBSession sharedSession])
        {
            DBSession* session = 
            [[DBSession alloc] initWithConsumerKey:@"ych32k07fi427wq" consumerSecret:@"8yq4k5icqoqguic"];
            session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
            [DBSession setSharedSession:session];
        }
        self->themeName = themeName;
        self->controller = controller;
        self->tm = [[ThemeManager alloc] initWithDirectoryName:themeName];
    }
    return self;
}

-(id)init
{
    return  [self initWithThemeName:nil];
}

-(void)initializeDropBoxModule
{
    //Check if dropbox account is linked
    if (![[DBSession sharedSession] isLinked]) {
        DBLoginController* controller =[DBLoginController new];
        controller.delegate = self;
        [controller presentFromController:controller];
    } else {
        [[DBSession sharedSession] unlink];
        [[[UIAlertView alloc] 
          initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
         show];
        [self updateButtons];
    }
    self->isInitialized = YES;
}

-(BOOL)uploadTheme
{
    if (!isInitialized)
    {
        [self initializeDropBoxModule];
    }
    
    self.errorsDuringUpload = NO;
    self.networkOpState = uploadNotStarted;
    [self.restClient createFolder:DBRoot];
    return  YES;
}

-(BOOL)downloadTheme
{
    if (!isInitialized)
    {
        [self initializeDropBoxModule];
    }
    
    self.errorsDuringDownload = NO;
    self.networkOpState = downloadNotStarted;
    [self.restClient loadMetadata:[DBRoot stringByAppendingPathComponent:themeName]];
    
    return YES;
}

#pragma mark DBRestClientDelegate methods

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    NSMutableArray* arr = [NSMutableArray new];
 
    for (DBMetadata* child in metadata.contents)
    {
        [arr addObject:child.path];
    }
    
    self.filesToDownload = arr;
    
    [self downloadFiles];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {

    NSLog(@"loadMetadata failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    self.errorsDuringDownload = YES;
    self.networkOpState = downloadCompleted;
}

-(void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    //verify that the file was loaded correctly. 
    NSFileManager *fm = [[NSFileManager alloc] init];
    if (![fm fileExistsAtPath:destPath])
    {
        NSLog(@"File did not download to location %@", destPath);
        self.errorsDuringDownload = YES;
    }
    //best effort behavior. If the download did not succeed, we continue to the next file
    [self downloadFiles];
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    NSLog(@"loadFile failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    //best effort behavior. If the download did not succeed, we continue to next file
    self.errorsDuringDownload = YES;
    [self downloadFiles];
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath
{
    NSLog(@"File was uploaded correctly to location %@", destPath);
    [self uploadFiles];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    NSLog(@"uploadFile failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    self.errorsDuringUpload = YES;
    //best effort behavior. try and upload the next file
    [self uploadFiles];
}

- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
{
    if ([[folder.path lowercaseString] isEqualToString:[DBRoot lowercaseString]])
    {
        //create soundboard theme folder
        [self.restClient createFolder:[DBRoot stringByAppendingPathComponent:self->themeName]];
    }
    else
    {
        [self uploadFiles];
    }
}

- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error
{
    NSLog(@"createFolder failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    //@TODO: Handle error where soundboard and/or theme dir already exists

}


#pragma  mark private methods

-(void)uploadFiles
{
    if (self.networkOpState == uploadNotStarted)
    {
        //start the upload process
        NSMutableArray* arr = [NSMutableArray new];
        NSString* copyFromDir = [[self->tm GetThemeDirURL] path];
        NSFileManager* fm = [[NSFileManager alloc] init];
        NSDirectoryEnumerator* dir = [fm enumeratorAtPath:copyFromDir];
        //upload all files in local directory one by one
        for (NSString* file in dir) {
            [arr addObject:file];
        }
    }
    if ([self.filesToUpload count] != 0)
    {
        NSString* fileToUpload = [self.filesToUpload objectAtIndex:0];
        [self.filesToUpload removeObjectAtIndex:0];
        self.networkOpState = uploadInProgress;
        [self.restClient uploadFile:fileToUpload toPath:[DBRoot stringByAppendingPathComponent:self->themeName] fromPath:[[self->tm GetThemeDirURL] path]];
    }
    else
    {
        self.networkOpState = uploadCompleted;
    }
}
         
-(void)downloadFiles
{
    if ([self.filesToDownload count] != 0)
    {
        NSString* fileToDownload = [self.filesToDownload objectAtIndex:0];
        [self.filesToDownload removeObjectAtIndex:0];
        NSString* filename = [fileToDownload lastPathComponent];
        NSString* themeDir = [[self->tm GetThemeDirURL] path];
        self.networkOpState = downloadInProgess;
        [self.restClient loadFile:fileToDownload intoPath:[themeDir stringByAppendingPathComponent:filename]];
    }
    else
    {
        self.networkOpState = downloadCompleted;
    }
}

- (DBRestClient*)restClient {
    if (restClient == nil) {
    	restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    	restClient.delegate = self;
    }
    return restClient;
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	DBLoginController* loginController = [DBLoginController new];
	//[loginController presentFromController:navigationController];
}


@end
