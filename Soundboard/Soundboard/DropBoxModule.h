//
//  DropBoxModule.h
//  Soundboard
//
//  Created by Ibrahim Shareef on 10/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxSDK.h"

@interface DropBoxModule : NSObject
{
    DBRestClient* restClient;
}


@end
