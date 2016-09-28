//
//  KSSDocument.m
//  kss
//
//  Created by Valken on 29.10.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "KSSDocument.h"


@implementation KSSDocument

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
	NSString *filePath = [absoluteURL path];
    NSLog(@"%@", filePath);
    
	myKssObject = [[kssObject alloc] init];

	[myKssObject fileDraged:filePath type:typeName];
	
	[myKssObject release];
	
	return YES;
}

@end
