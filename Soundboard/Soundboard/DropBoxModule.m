//
//  DropBoxModule.m
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DropBoxModule.h"


NSString* DBRoot = @"/Public/Soundboard/";


@interface DropBoxModule() <DBRestClientDelegate, DBSessionDelegate>
{
    NSString* themeName;
    UIViewController* controller;
}

-(void) uploadFiles;
//-(void) initializeDropBoxModule;
-(void) downloadFiles;

@property (nonatomic, readonly) DBRestClient* restClient;
@property (atomic, retain) NSMutableArray* filesToDownload;
@property (atomic, retain) NSMutableArray* filesToUpload;

@end

@implementation DropBoxModule

@synthesize filesToDownload, filesToUpload, errorsDuringUpload, errorsDuringDownload, networkOpState;

-(id)initWithThemeName:(NSString *)name
{
    self =[super init];
    if (self)
    {
        //set the shared session, if it already has not been done
        if (nil == [DBSession sharedSession])
        {
            DBSession* dbSession =
            [[DBSession alloc]
              initWithAppKey:@"ych32k07fi427wq"
              appSecret:@"8yq4k5icqoqguic"
              root:@"dropbox"]; // either kDBRootAppFolder or kDBRootDropbox
            [DBSession setSharedSession:dbSession];
            
            /*DBSession* session = 
            [[DBSession alloc] initWithConsumerKey:@"ych32k07fi427wq" consumerSecret:@"8yq4k5icqoqguic"];
            session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
            [DBSession setSharedSession:session];*/
        }
        self->themeName = name;
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
    if (!self->isInitialized)
    {
        if (![[DBSession sharedSession] isLinked]) {
            [[DBSession sharedSession] link];
        }
        else
        {
            self->isInitialized = YES; 
        }
    }
    /*else {
        [[DBSession sharedSession] unlink];
        [[[UIAlertView alloc] 
          initWithTitle:@"Account Unlinked!" message:@"Your dropbox account has been unlinked" 
          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
         show];
    }*/
}

-(BOOL)GetThemeShareURL
{
    [self.restClient loadSharableLinkForFile:[DBRoot stringByAppendingPathComponent:self->themeName]];
}

-(BOOL)UploadTheme
{
    
    [self initializeDropBoxModule];
    
    if (isInitialized)
    {
        self.errorsDuringUpload = NO;
        self.networkOpState = uploadNotStarted;
        [self.restClient createFolder:[DBRoot stringByAppendingPathComponent:self->themeName]];
        return  YES;
    }
    return NO;
}

-(BOOL)DownloadTheme
{
    [self initializeDropBoxModule];
        
    if (isInitialized)
    {
        self.errorsDuringDownload = NO;
        self.networkOpState = downloadNotStarted;
        [self.restClient loadMetadata:[DBRoot stringByAppendingPathComponent:themeName]];
        return YES;
    }
    return NO;
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
    NSLog(@"uploadFile failed with the following error: %@\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", error, [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    
    NSDictionary* dict = [error userInfo];
    
    if (nil != dict) 
    {
        for (NSString* key in dict) {
            NSLog(@"Key: %@ Value: %@", key, [dict objectForKey:key]);
        }
    }
    
    self.errorsDuringUpload = YES;
    //best effort behavior. try and upload the next file
    [self uploadFiles];
}

- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
{
    NSLog(@"Created folder %@ on dropbox", folder.path);
    
    [self uploadFiles];
    
}

- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error
{
    NSLog(@"createFolder failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
    //Handle error where soundboard and/or theme dir already exists
    if ([[error domain] isEqualToString:@"dropbox.com"] && [error code] == 403)
    {
        NSLog(@"Directory already exists. Continuing with the upload...");
        [self uploadFiles];
    }

}

- (void)restClient:(DBRestClient*)restClient loadedSharableLink:(NSString*)link forFile:(NSString*) path
{
        NSLog(@"Got shareable link: %@", link);
}

         
- (void)restClient:(DBRestClient*)restClient loadSharableLinkFailedWithError:(NSError*)error
{
         NSLog(@"loadSharableLink failed with the following error: %@\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", error, [error domain], [error code], [error localizedDescription], [error localizedFailureReason] );
         
         NSDictionary* dict = [error userInfo];
         
         if (nil != dict) 
         {
             for (NSString* key in dict) {
                 NSLog(@"Key: %@ Value: %@", key, [dict objectForKey:key]);
             }
         }
}
                                                                                         



#pragma  mark private methods

-(void)uploadFiles
{
    if (self.networkOpState == uploadNotStarted)
    {
        //start the upload process
        NSLog(@"Starting the upload process...");
        NSMutableArray* arr = [NSMutableArray new];
        NSFileManager* fm = [[NSFileManager alloc] init];
        NSDirectoryEnumerator* dir = [fm enumeratorAtPath:tm.themeDirPath];
        //upload all files in local directory one by one
        for (NSString* file in dir) {
            [arr addObject:file];
        }
        self.filesToUpload = arr;
    }
    if ([self.filesToUpload count] != 0)
    {
        NSString* fileToUpload = [self.filesToUpload objectAtIndex:0];
        NSLog(@"Uploading file %@...", fileToUpload);
        [self.filesToUpload removeObjectAtIndex:0];
        self.networkOpState = uploadInProgress;
        [self.restClient uploadFile:fileToUpload toPath:[DBRoot stringByAppendingPathComponent:self->themeName] withParentRev:nil fromPath:[tm.themeDirPath stringByAppendingPathComponent:fileToUpload]];
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
        NSString* themeDir = tm.themeDirPath;
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
	//DBLoginController* loginController = [DBLoginController new];
	//[loginController presentFromController:navigationController];
}

/*- (void)loginControllerDidLogin:(DBLoginController*)controller
{
    if (self.networkOpState == uploadNotStarted)
    {
        [self uploadTheme];
    }
    else if (self.networkOpState == downloadNotStarted)
    {
        [self downloadTheme];
    }
}

- (void)loginControllerDidCancel:(DBLoginController*)controller
{
    
}*/


@end
