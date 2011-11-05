//
//  ThemeManager.m
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ThemeManager.h"
#import "SoundBoardError.h"

@interface ThemeManager ()

@property (nonatomic,readonly) NSFileManager* appFileManager;

-(NSURL*)GetApplicationSupportDirectory : (NSError**) err;

@end


@implementation ThemeManager

+(NSArray*)GetThemes:(NSError *)error
{
    
}

-(id)initWithDirectoryName:(NSString *)dirname
{
    self = [super init];
    if (self)
    {
        self->isInitialized = NO;
        self->themeDirName = dirname;
    }
    return self;
}

-(id)init
{
    return [self initWithDirectoryName:nil];
}

-(NSFileManager*) appFileManager
{
    if (fm == nil)
    {
        fm = [[NSFileManager alloc] init];
    }
    return  fm;
}

-(NSURL*)GetApplicationSupportDirectory:(NSError *__autoreleasing *)err
{
    if (suppurl == nil)
    {
        suppurl = [self.appFileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:err];
    }
    return suppurl;
}


-(BOOL)CreateDirectory:(NSString *)directoryName error:(NSError *__autoreleasing *)err
{
    self->themeDirName = directoryName;
    
    NSError* internalerr = nil;
    
    NSURL* appDirUrl = [self GetApplicationSupportDirectory:&internalerr];
    
    if (nil == appDirUrl)
    {
        NSLog(@"URLForDirectory failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [internalerr domain], [internalerr code], [internalerr localizedDescription], [internalerr localizedFailureReason] );
        
        if (nil != err)
        {
            *err = internalerr;
        }
        return  NO;
    }
    NSString* currThemeDir = [[appDirUrl path] stringByAppendingPathComponent:directoryName];
    if (![self.appFileManager fileExistsAtPath:currThemeDir])
    {
        //create the directory
        BOOL ret = [self.appFileManager createDirectoryAtPath:currThemeDir withIntermediateDirectories:NO attributes:nil error:&internalerr];
        
        if (!ret)
        {
            NSLog(@"createDirectoryAtPath failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [internalerr domain], [internalerr code], [internalerr localizedDescription], [internalerr localizedFailureReason] );
            
            if (nil != err)
            {
                *err = internalerr;
            }
            return  NO;
        }
    }
    
    self->themeDirURL = [[NSURL alloc] initFileURLWithPath:currThemeDir];
    self->isInitialized = YES;
    
    return YES;
}

-(BOOL)DeleteFile:(NSString*)filename error:(NSError *__autoreleasing *)err
{
    if (!isInitialized)
    {
        NSArray* objArray = [NSArray arrayWithObjects:@"Theme object not initialized. Call CreateDirectory First", nil];
        NSArray* keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
        NSDictionary* eDict = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
        *err = [[NSError alloc] initWithDomain:SoundBoardErrorDomain code:ThemeObjectNotInitialized userInfo:eDict];
        return  NO;   
    }
    NSString* fileToDelete = [[themeDirURL path] stringByAppendingPathComponent:filename];
    NSError* internalerr = nil;
    BOOL ret = [self.appFileManager removeItemAtPath:fileToDelete error:&internalerr];
    if (!ret)
    {
        NSLog(@"removeItemAtPath failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [internalerr domain], [internalerr code], [internalerr localizedDescription], [internalerr localizedFailureReason] );
        
        //@TODO: Should check if the file does not exist error is returned, and reset error before returning to caller
        if (nil != err)
        {
            *err = internalerr;
        }
        return  NO;
    }
    return  YES;
}

-(BOOL)AddFile:(NSURL *)file error:(NSError *__autoreleasing *)err
{
    if (!isInitialized)
    {
        NSArray* objArray = [NSArray arrayWithObjects:@"Theme object not initialized. Call CreateDirectory First", nil];
        NSArray* keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
        NSDictionary* eDict = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
        *err = [[NSError alloc] initWithDomain:SoundBoardErrorDomain code:ThemeObjectNotInitialized userInfo:eDict];
        return  NO;
        
    }
    
    NSString* destPath = [[themeDirURL path] stringByAppendingPathComponent:[file lastPathComponent]];
    NSError* internalerr = nil;
    if ([self.appFileManager fileExistsAtPath:destPath])
    {
        BOOL ret = [self.appFileManager removeItemAtPath:destPath error:&internalerr];
        if (!ret)
        {
            NSLog(@"removeItemAtPath failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [internalerr domain], [internalerr code], [internalerr localizedDescription], [internalerr localizedFailureReason] );
            
            if (nil != err)
            {
                *err = internalerr;
            }
            return  NO;
        }
        
    }
    internalerr = nil;
    BOOL ret = [self.appFileManager copyItemAtPath:[file path] toPath:destPath error:&internalerr];
    if (!ret)
    {
        NSLog(@"copyItemAtPath failed with the following error:\n Error Domain: %@\n Error Code: %d\n, Error description: %@\n Failure Reason: %@", [internalerr domain], [internalerr code], [internalerr localizedDescription], [internalerr localizedFailureReason] );
        
        if (nil != err)
        {
            *err = internalerr;
        }
        return  NO;
    }
    return  YES;
}

-(NSURL*)GetFile:(NSString *)filename error:(NSError *__autoreleasing *) err
{
    if (!isInitialized)
    {
        NSArray* objArray = [NSArray arrayWithObjects:@"Theme object not initialized. Call CreateDirectory First", nil];
        NSArray* keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
        NSDictionary* eDict = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
        *err = [[NSError alloc] initWithDomain:SoundBoardErrorDomain code:ThemeObjectNotInitialized userInfo:eDict];
        return  nil;
        
    }
    NSString* filepath = [[themeDirURL path] stringByAppendingPathComponent:filename];
    if (![self.appFileManager fileExistsAtPath:filepath])
    {
        NSArray* objArray = [NSArray arrayWithObjects:@"Theme file does not exist.", nil];
        NSArray* keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
        NSDictionary* eDict = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
        *err = [[NSError alloc] initWithDomain:SoundBoardErrorDomain code:ThemeFileDoesNotExist userInfo:eDict];
        return  nil;
    }
    NSURL *fileurl = [[NSURL alloc] initFileURLWithPath:filepath];
    return fileurl;
}


@end
