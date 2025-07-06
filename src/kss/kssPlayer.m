#import "kssPlayer.h"

@implementation kssPlayer

-(int)aleatoire:(int)min maximum:(int)max
{
    int value;
    time_t t1;
    do
    {
        t1=clock();
        value=rand()*t1/100000000000000;
    }while (value < min || value > max);
    return value;    
}



-(void)onDoubleClick
{	
	NSString *myTime;

	selectedPlayListItem = (int)[playListTableView selectedRow];
    
	if(![[playerKSS kssFile] isEqual:[[m3uArray objectAtIndex:selectedPlayListItem] objectForKey:@"fileLocation"]])
	{
		if([playerKSS setKssFile:[[m3uArray objectAtIndex:selectedPlayListItem] objectForKey:@"fileLocation"]])
		{
			if(![playerKSS fileOpen])
			{
				[playerKSS setFileOpen:1];

				[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
				[playerKSS setSongTime:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]];
				 
	//			 [[tempObject duration] intValue]];

				[playerKSS play];
			
				[playButton setImage:[NSImage imageNamed:@"pause"]];
				[playButton setAlternateImage:[NSImage imageNamed:@"pause_blue"]];
		
			}
			else
			{
			
				[playButton setImage:[NSImage imageNamed:@"pause"]];
				[playButton setAlternateImage:[NSImage imageNamed:@"pause_blue"]];

				[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
			}

		}
        
		[trackNameOutlet setStringValue:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackTitle"]];
		timeToChange = [[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]; 

	}
	else
	{
		[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
		[playerKSS setSongTime:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]];
		[playerKSS setFadeOutTime:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackFadeOut"] intValue]];	
		[playerKSS play];
			
		[playButton setImage:[NSImage imageNamed:@"pause"]];
		[playButton setAlternateImage:[NSImage imageNamed:@"pause_blue"]];
					

		[trackNameOutlet setStringValue:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackTitle"]];
		timeToChange = [[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]; 

	}
	myTime = [NSString stringWithFormat: @"%d:%02d:%02d",(int) (0 / (60 * 60)),(int) (0 / 60 % 60),(int) (0 % 60)];
	[playTime setStringValue:myTime];

}

-(IBAction)timeToDisplay:(id)sender
{
	if(timeToShow)timeToShow=0;
	else timeToShow=1;
}


- (void)updateProgressBar
{
	NSString *myTime;
	
	if([playerKSS playTime] > 4000)
		[self onDoubleClick];
    
    myTime = [NSString stringWithFormat: @"%d:%02d:%02d",(int) ([playerKSS playTime] / (60 * 60)),(int) ([playerKSS playTime] / 60 % 60),(int) ([playerKSS playTime] % 60)];

	
    __block int respect;

    dispatch_async(dispatch_get_main_queue(),^ {
        respect = [respectTime intValue];
        [playTime setStringValue:myTime];
    });
    
	if([m3uArray count])
	{
//        if(([playerKSS playTime]>=[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]) && (![respectTime intValue]))

	if(([playerKSS playTime]>=[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]) && respect)
	{
        
		NSIndexSet *myIndex;
		
		myTime = [NSString stringWithFormat: @"%d:%02d:%02d",(int) (0 / (60 * 60)),(int) (0 / 60 % 60),(int) (0 % 60)];

        dispatch_async(dispatch_get_main_queue(),^ {
            if([randomOutlet state])
            {
                selectedPlayListItem = [self aleatoire:0 maximum:[m3uArray count]-1];
            }
            else
            {
                selectedPlayListItem++;
                if(selectedPlayListItem  >= [m3uArray count])selectedPlayListItem=0;
            }
        });

	
		timeToChange = [[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue];//[tempObject intDuration];
		myIndex = [NSIndexSet indexSetWithIndex:selectedPlayListItem+1];
	
        dispatch_async(dispatch_get_main_queue(),^ {
            [playListTableView selectRowIndexes:myIndex byExtendingSelection:0];
        });
        
		if([playerKSS setKssFile:[[m3uArray objectAtIndex:selectedPlayListItem] objectForKey:@"fileLocation"]])
		{
			if(![playerKSS fileOpen])
			{
				[playerKSS setFileOpen:1];

				[playerKSS updateKss:1];
				[playerKSS setSongNumber:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"]];
			}
			else
			{
				[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
			}
            
            dispatch_async(dispatch_get_main_queue(),^ {
                [trackNameOutlet setStringValue:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackTitle"]];
                timeToChange = [[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue];
			});
		}

        dispatch_async(dispatch_get_main_queue(),^ {
            [playTime setStringValue:myTime];
        });
	}

	}
	 
}

	
- (void)awakeFromNib
{
	playerKSS = [[kssObject alloc] init];
    myAudioToolBox = [[AUDIOToolbox alloc] init];
    
	NSNotificationCenter *nc;
	[playListTableView setDoubleAction:@selector(onDoubleClick)];    
	
	nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(resetSongStartTime)
		name:@"songRestarted"
		object:nil];

	[nc addObserver:self selector:@selector(updateProgressBar)
		name:@"SongPositionChanged"
		object:nil];

	[nc addObserver:self selector:@selector(updateSongTitle)
		name:@"songFileChanged"
		object:nil];
	[nc addObserver:self selector:@selector(updateVolumes)
		name:@"volumeChanged"
		object:nil];
	[nc addObserver:self selector:@selector(openFile)
		name:@"dragedFile"
		object:nil];
	[nc addObserver:self selector:@selector(updateProgressBar)
			   name:@"timeChanged"
			 object:nil];		
    
	timeToChange = 60;
	selectedPlayListItem = 0;

	[playListTableView registerForDraggedTypes:[NSArray arrayWithObject: NSFilenamesPboardType] ];


}

-(IBAction)openM3u:(id)sender
{
	NSOpenPanel	*op = [NSOpenPanel openPanel];
	
	[op setAllowedFileTypes:[NSArray arrayWithObjects: @"m3u",@"k3u",@"kss",@"mpk",@"opx",@"mgs",@"mbm",@"bgm",@"bgr", nil]];
   
    if([op runModal])
	{
		NSURL *names;
		NSString *filePath;
		
		names = [op URL];
		filePath = [names path];
        
		[playerKSS setm3uFileLocation:filePath type:[filePath pathExtension]];
        [playListTableView needsDisplay];
		[self openFile];
	}
}

- (NSMutableArray *)parseM3uFile:(NSString *)fileLocation

{

//	NSAutoreleasePool * localPool = [[NSAutoreleasePool alloc] init];
	
	NSMutableArray *thePlayListArray;

	thePlayListArray = [[NSMutableArray alloc] init];

	myParser = [[m3uParser alloc] init];
	
	thePlayListArray = [myParser parseM3uFile:fileLocation];
    
    [myParser release];
    
	//[thePlayListArray writeToFile:@"/Users/valken/test.klist" atomically:NO];
	return thePlayListArray;
	//	[localPool release];

}


-(void)openFile
{
//	NSAutoreleasePool * localPool = [[NSAutoreleasePool alloc] init];

	NSString *tempString = [[playerKSS m3uFileLocation] lowercaseString];
	
	if([[tempString pathExtension] isEqual:@"m3u"] || [[tempString pathExtension] isEqual:@"k3u"])
	{
		m3uArray = [self parseM3uFile:[playerKSS m3uFileLocation]];
	}
	else if ([[tempString pathExtension] isEqual:@"kss"] || [[tempString pathExtension] isEqual:@"mgs"] || [[tempString pathExtension] isEqual:@"opx"] || [[tempString pathExtension] isEqual:@"mpk"] || [[tempString pathExtension] isEqual:@"mbm"] || [[tempString pathExtension] isEqual:@"bgm"] || [[tempString pathExtension] isEqual:@"bgr"])
	{
		m3uArray = [self openKss];
        
    [playListTableView reloadData];

		NSIndexSet *myIndex;
		
		myIndex = [NSIndexSet indexSetWithIndex:0];

		[playListTableView selectRowIndexes:myIndex byExtendingSelection:NO];
        
		[self onDoubleClick];
	}
    [playListTableView reloadData];

    NSIndexSet *myIndex;
    myIndex = [NSIndexSet indexSetWithIndex:0];


    dispatch_async(dispatch_get_main_queue(),^ {
        [playListTableView selectRowIndexes:myIndex byExtendingSelection:NO];
    });

    selectedPlayListItem = 0;
    [self onDoubleClick];
    
//	[localPool release];
	
}


-(NSMutableArray *)openKss
{
	NSAutoreleasePool * localPool = [[NSAutoreleasePool alloc] init];
    selectedPlayListItem=0;
	NSString *kssFileLocation = [playerKSS m3uFileLocation];
	int totalPlayTime;
	NSArray *keys = [NSArray arrayWithObjects:@"fileActivated", @"fileLocation", @"fileType", @"trackNumber", @"trackTitle", @"trackDuration", @"trackLoopTime", @"trackFadeOut", nil];

	totalPlayTime = 0;
	
	int i=0;
	
	NSMutableArray *thePlayListArray;

	thePlayListArray = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *m3uDictionary;
	
	m3uArray = [[NSMutableArray alloc] init];	
	
	for(i=0;i<=255;i++)
	{
		NSMutableArray *splitedStrings;
		
		splitedStrings = [[NSMutableArray alloc] init];
		
		
		[splitedStrings addObject:@"1"];
		[splitedStrings addObject:kssFileLocation];
		[splitedStrings addObject:@"KSS"];
		[splitedStrings addObject:[NSNumber numberWithInt:i]];
		[splitedStrings addObject:@"No title specified"];
        [splitedStrings addObject:[NSNumber numberWithInt:[playerKSS defaultPlayTime]]];
		[splitedStrings addObject:@"0"];
		[splitedStrings addObject:@"0"];
		
		m3uDictionary = [[NSMutableDictionary alloc] init];
		
		m3uDictionary = [NSMutableDictionary dictionaryWithObjects:splitedStrings forKeys:keys];
		
		[thePlayListArray addObject:m3uDictionary];
		
	}
	[kssFileLocation release];
	
    [localPool release];

    return thePlayListArray;
	
}



-(void)updateVolumes
{	
	[masterVolumeOutlet setIntValue:[playerKSS masterVolume]];
}
-(void)updateImage
{
	NSFileManager *myJpgFile =  [NSFileManager defaultManager];
	
	if([myJpgFile fileExistsAtPath:[[[playerKSS kssFile] stringByDeletingPathExtension] stringByAppendingString:@".png"]]) 
	{
		NSString *jpgFileLocation = [[[playerKSS kssFile] stringByDeletingPathExtension] stringByAppendingString:@".png"];
		NSImage * kssGameImage = [[NSImage alloc] initWithContentsOfFile:jpgFileLocation];
		[kssImage setImage:kssGameImage];
		[kssGameImage release];
		//[kssImage setSize:[kssGameImage size]];
	}
	else
	{
		[kssImage setImage:nil];
	}
}

-(void)updateSongTitle
{
	[songTitle setStringValue:[[playerKSS kssFile]lastPathComponent]];
	[directAccessOutlet setIntValue:[playerKSS songNumber]];
	[masterVolumeOutlet setIntValue:[playerKSS masterVolume]];
	
	//printf("%i\n",[[playerKSS size] intValue]);

}


- (IBAction)masterVolume:(id)sender
{
	[playerKSS changeMasterVolume:[sender intValue]];
}



- (IBAction)next:(id)sender
{
	NSString *myTime;
	
//	m3uObject *tempObject;
//	NSIndexSet *myIndex;
	if([playerKSS fileOpen])
	{
		NSIndexSet *myIndex;
		
		if([randomOutlet state])
		{
			selectedPlayListItem = [self aleatoire:0 maximum:[m3uArray count]-1];
		}
		else
		{
			selectedPlayListItem++;
			if(selectedPlayListItem  >= [m3uArray count])selectedPlayListItem=0;
		}
		//	if(selectedPlayListItem >= [m3uArray count])selectedPlayListItem = 0;

		//tempObject = [m3uArray objectAtIndex:selectedPlayListItem];
	
		myIndex = [NSIndexSet indexSetWithIndex:selectedPlayListItem];
	
		[playListTableView selectRowIndexes:myIndex byExtendingSelection:0];
        
		if([playerKSS setKssFile:[[m3uArray objectAtIndex:selectedPlayListItem] objectForKey:@"fileLocation"]])
		{
			[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
			 
			[playerKSS setSongTime:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue]];
//			//	 [[tempObject duration] intValue]];

			timeToChange = [[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue];
			
//			[tempObject intDuration];
				[trackNameOutlet setStringValue:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackTitle"]];
				
			
		}
		//[self updateImage];

	}	

	myTime = [NSString stringWithFormat: @"%d:%02d:%02d",(int) (0 / (60 * 60)),(int) (0 / 60 % 60),(int) (0 % 60)];
	[playTime setStringValue:myTime];
	
}



- (IBAction)playListToggle:(id)sender
{
	//NSLog(@"We must toggle the windows size here");
}

- (IBAction)previous:(id)sender
{
	NSString *myTime;
	//m3uObject *tempObject;
	NSIndexSet *myIndex;
	if([playerKSS fileOpen])
	{
		if([playerKSS playTime] <=2)
		{
			selectedPlayListItem--;
			if(selectedPlayListItem < 0)selectedPlayListItem = [m3uArray count]-1;
	
			if([playerKSS setKssFile:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"fileLocation"]])
			{
				[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
				myIndex = [NSIndexSet indexSetWithIndex:selectedPlayListItem];
	
				[playListTableView selectRowIndexes:myIndex byExtendingSelection:0];
				timeToChange = [[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackDuration"] intValue];
									

				[trackNameOutlet setStringValue:[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackTitle"]];
			}
		}
		else
		{
			[playerKSS setSongNumber:[[[m3uArray objectAtIndex:selectedPlayListItem] valueForKey:@"trackNumber"] intValue]];
		}
	}
	myTime = [NSString stringWithFormat: @"%d:%02d:%02d",(int) (0 / (60 * 60)),(int) (0 / 60 % 60),(int) (0 % 60)];
	[playTime setStringValue:myTime];


}



- (IBAction)togglePause:(id)sender
{

	if([playerKSS isRunning])
//    if([playerKSS fileOpen])
	{
		[playButton setImage:[NSImage imageNamed:@"play"]];
		[playButton setAlternateImage:[NSImage imageNamed:@"play_blue"]];
	}
	else
	{
		[playButton setImage:[NSImage imageNamed:@"pause"]];
		[playButton setAlternateImage:[NSImage imageNamed:@"pause_blue"]];
	}

	[playerKSS togglePause];
}

- (IBAction)volumeHigh:(id)sender
{
	//NSString *shortFileName;

	[playerKSS changeMasterVolume:[masterVolumeOutlet intValue]+5];
	[masterVolumeOutlet setIntValue:[masterVolumeOutlet intValue]+5];
}

- (IBAction)volumeLow:(id)sender
{
	[playerKSS changeMasterVolume:[masterVolumeOutlet intValue]-5];
	[masterVolumeOutlet setIntValue:[masterVolumeOutlet intValue]-5]; 
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [m3uArray count];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes         toPasteboard:(NSPasteboard*)pboard
{
return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op
{
    return NSDragOperationCopy;
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
          row:(int)row dropOperation:(NSTableViewDropOperation)operation
{
    return YES;
}

-(id)tableView:(NSTableView *)aTableView
	objectValueForTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex
{
	if([[aTableColumn identifier] isEqual:@"trackDuration"])
	{
		NSString *myTime;
		myTime = [NSString stringWithFormat: @"%d:%02d:%02d",(int) ([[[m3uArray objectAtIndex:rowIndex] valueForKey:@"trackDuration"] intValue] / (60 * 60)),(int) ([[[m3uArray objectAtIndex:rowIndex] valueForKey:@"trackDuration"] intValue] / 60 % 60),(int) ([[[m3uArray objectAtIndex:rowIndex] valueForKey:@"trackDuration"] intValue] % 60)];
		return myTime;
	}
	else
        return [[m3uArray objectAtIndex:rowIndex] valueForKey:[aTableColumn identifier]];
}


-(void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
	row:(int)rowIndex
{
	
  if([[aTableColumn identifier] isEqual:@"trackDuration"])
  {
		NSString *modifiedTime;
		modifiedTime = [[myAudioToolBox timeDecomp:anObject] stringValue];
		[[m3uArray objectAtIndex:rowIndex]  setValue:modifiedTime forKey:[aTableColumn identifier]];
   }	
  else
	{
		[[m3uArray objectAtIndex:rowIndex]  setValue:anObject forKey:[aTableColumn identifier]];
   }
   
   
}



@end

