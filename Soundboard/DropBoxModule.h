//
//  DropBoxModule.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxSDK.h"
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

-(id)initWithThemeName:(NSString*)themeName;
-(BOOL)uploadTheme;
-(BOOL)downloadTheme;

@property (nonatomic) BOOL errorsDuringDownload;
@property (nonatomic) BOOL errorsDuringUpload;
@property (atomic) NetworkOperationState networkOpState;

@end
