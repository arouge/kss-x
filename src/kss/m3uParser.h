//
//  m3uParser.h
//  
//
//  Created by Valken on 16.11.09.
//  Copyright 2009 City-Hunter. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AUDIOToolbox.h"

@interface m3uParser : NSObject {
    AUDIOToolbox *myAudioToolBox;
}
	
- (NSMutableArray *)parseM3uFile:(NSString *)fileLocation;

@end
