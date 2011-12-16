//
//  DropBoxModule.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>
#import "ThemeManager.h"


typedef enum
{
    downloadNotStarted,
    downloadInProgess,
    downloadCompleted,
    uploadNotStarted,
    uploadInProgress,
    uploadCompleted
}NetworkOperationState;

typedef enum
{
    uploadOperation,
    downloadOperation
}CurrentOperationType;

@interface DropBoxModule : NSObject
{
    DBRestClient* restClient;
    BOOL isInitialized;
    NSError* restClientError;
    ThemeManager* tm;
}

-(void)initializeDropBoxModule;
-(id)initWithThemeName:(NSString*)themeName;
-(BOOL)UploadTheme;
-(BOOL)DownloadTheme;
-(BOOL)GetThemeShareURL;


@property (nonatomic, assign) BOOL errorsDuringDownload;
@property (nonatomic, assign) BOOL errorsDuringUpload;
@property (atomic, assign) NetworkOperationState networkOpState;

@end
