//
//  m3uParser.m
//  
//
//  Created by Valken on 16.11.09.
//  Copyright 2009 City-Hunter. All rights reserved.
//

#import "m3uParser.h"

@implementation m3uParser

- (NSMutableArray *)parseM3uFile:(NSString *)fileLocation {
	NSString *m3uFile;
	NSMutableArray *thePlayListArray;
    NSStringEncoding encoding;
    myAudioToolBox = [[AUDIOToolbox alloc] init];
    
	NSArray *keys = [NSArray arrayWithObjects:@"fileActivated", @"fileLocation", @"fileType", @"trackNumber", @"trackTitle", @"trackDuration", @"trackLoopTime", @"trackFadeOut", nil];
	
	NSMutableDictionary *m3uDictionary;

    m3uFile = [[NSString alloc] initWithContentsOfFile:fileLocation usedEncoding:&encoding error:NULL];
    
	m3uFile = [m3uFile stringByReplacingOccurrencesOfString:@"::" withString:@","];
	m3uFile = [m3uFile stringByReplacingOccurrencesOfString:@"\\," withString:@"[m3uVirgule!@#$%^&*()]"];
	
	thePlayListArray = [[NSMutableArray alloc] init];
	
    NSArray * newTestArray = [m3uFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for(int numberOfLine=0; numberOfLine < [newTestArray count]; numberOfLine++)
    {

        if(![[newTestArray objectAtIndex:numberOfLine] length])
            continue; 
        if([[newTestArray objectAtIndex:numberOfLine] characterAtIndex:0] == 35)
            continue;
    
		NSString *tempLineString = @"1,"; //You need this to enable or disable a item in the playlist.
        NSString *theLine = [newTestArray objectAtIndex:numberOfLine];
        
        NSMutableArray *lineArray;
		tempLineString = [tempLineString stringByAppendingString:theLine];
			
        lineArray = [NSMutableArray arrayWithArray:[tempLineString componentsSeparatedByString:@","]];
			
			if([lineArray count] < 8)
			{
				for(int i=0;(i=(int)(8-[lineArray count]));i++)
					if(i == 5)
						[lineArray replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:60]];
				else 

					[lineArray addObject:@"Undefined"];				
			}
			if([lineArray count] > 8)
			{
				for(int i=0;(i=(int)([lineArray count]-8));i++)
					[lineArray removeLastObject];
			}
			
			[lineArray replaceObjectAtIndex:4 withObject:[[lineArray objectAtIndex:4] stringByReplacingOccurrencesOfString:@"[m3uVirgule!@#$%^&*()]" withString:@","]];
			
			[lineArray replaceObjectAtIndex:1 withObject:[[[fileLocation stringByDeletingLastPathComponent] stringByAppendingString:@"/"] stringByAppendingString:[lineArray objectAtIndex:1]]];
			
			if([[lineArray objectAtIndex:3] characterAtIndex:0] == 36)
			{
				NSScanner *hexaScanner;
				NSString *tempString;
				unsigned int tempNumber=0;
				
				tempString = [[lineArray objectAtIndex:3] copy];
				hexaScanner = [NSScanner scannerWithString:tempString];
				[hexaScanner setScanLocation:1];
				[hexaScanner scanHexInt:&tempNumber];
				[lineArray replaceObjectAtIndex:3 withObject:[[NSNumber numberWithUnsignedInt:tempNumber] stringValue]];
				[tempString release];
			}
			
        [lineArray replaceObjectAtIndex:5 withObject:[NSNumber numberWithInt:(int)[myAudioToolBox timeDecomp:[lineArray objectAtIndex:5]]]];
         
			
			m3uDictionary = [NSMutableDictionary dictionaryWithObjects:lineArray forKeys:keys];
			
			[thePlayListArray addObject:m3uDictionary];

	} // End of parsing
    
	return thePlayListArray;
}

@end
