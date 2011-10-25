//
//  SoundBoardError.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/21/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

extern NSString* const SoundBoardErrorDomain;

typedef enum {
    ThemeFileAlreadyExists,
    ThemeObjectNotInitialized,
    ThemeFileDoesNotExist
}SoundBoardErrorCode;
