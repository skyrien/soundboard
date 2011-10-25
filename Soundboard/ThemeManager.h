//
//  ThemeManager.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject
{
    NSString* themeDirName;
    NSURL* themeDirURL;
    NSFileManager* fm;
    NSURL* suppurl;
    BOOL isInitialized;
}

-(BOOL)CreateDirectory:(NSString*) directoryName error:(NSError**)err;
-(BOOL)AddFile:(CFURLRef*) file error:(NSError**)err;
-(NSURL*)GetFile:(NSString*) filename error:(NSError**)err;

@end
