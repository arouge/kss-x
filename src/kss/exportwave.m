#import "exportwave.h"
#import "kssplay.h"

@implementation exportwave

- (void)awakeFromNib
{
	exportKss = [[kssObject alloc] init];
	frequency = (int)[exportKss frameRate];
    calculationTime=0;
}

- (IBAction)cancelExport:(id)sender
{
	_isPlaying = NO;
	[cancelButtonOutlet setEnabled:NO];
	[exportButtonOutlet setEnabled:YES];
}

- (IBAction)exportAsWave:(id)sender
{
    
	if(!_isPlaying)
    {
		if((sourceFileChoosen) && (destFolderChoosen))
		{
            calculationTime=0;
			[cancelButtonOutlet setEnabled:YES];
			[exportButtonOutlet setEnabled:NO];
			[NSThread detachNewThreadSelector:@selector(kssProcessingFunction) toTarget:self withObject:nil];
		}
    }
}

- (void)kssProcessingFunction
{
	// Ici faire la boucle qui converti les fichiers en wave.
    
   // NSAutoreleasePool * localPool = [[NSAutoreleasePool alloc] init];
	int i=0;
    //	int l;
	int k=0;
    
	NSString *outputFileName;
	char fileNameC[256];
	_isPlaying = YES;
    
	kssplay = KSSPLAY_new(frequency, 2, 16) ;

	kssplay->opll_stereo = 1;
	KSSPLAY_set_device_quality(kssplay,EDSC_PSG,YES);
	KSSPLAY_set_device_quality(kssplay,EDSC_SCC,YES);
	KSSPLAY_set_device_quality(kssplay,EDSC_OPL,YES);
	KSSPLAY_set_device_quality(kssplay,EDSC_OPLL,YES);
    
	if([inheritDevicesOutlet intValue])
	{
		
		psgVolume = (int)[exportKss psgVolume];
		sccVolume = (int)[exportKss sccVolume];
		oplVolume = (int)[exportKss oplVolume];
		opllVolume = (int)[exportKss opllVolume];
		masterVolume = (int)[exportKss getMasterVolume];
		
		psgMask = (int)[exportKss psgMask];
		sccMask = (int)[exportKss sccMask];
		oplMask = (int)[exportKss oplMask];
		opllMask = (int)[exportKss opllMask];
		for(k=0;k<13;k++)
		{
			opllPan[k] = (int)[exportKss getOpllPan:k];
		}
	}
	else
	{
        psgVolume = 0;
        sccVolume = 0;
        oplVolume = 0;
        opllVolume = 0;
        masterVolume = 0;
        psgMask = 0;
        sccMask = 0;
        oplMask = 0;
        opllMask = 0;
        for(k=0;k<13;k++)
        {
            opllPan[k] = 3;
        }
	}
	
    dispatch_async(dispatch_get_main_queue(),^ {
        [progressbarOutlet setMaxValue:totalPlayTime];
    });
  
    //NSLog(@"Export débuté");

	for(i=0;i<[m3uArray count];i++)
	{
		int j;
		int k;
		
		short wavebuf[frequency*2];

		NSString *filePosition;
		
		filePosition = [[m3uArray objectAtIndex:i] valueForKey:@"fileLocation"];
		
		//NSLog(@"%@", filePosition);
		
		(void)strncpy(fileNameC,[filePosition UTF8String], sizeof(fileNameC));
		// Ici creer un nouveau fichier wave ... 01-fichierkss.wav
		outputFileName = [kssFileName copy];
        
		if(i<100)
		{
			if(i<10)
				outputFileName =  [outputFileName stringByAppendingString:@"-00"];
			else
				outputFileName =  [outputFileName stringByAppendingString:@"-0"];
		}
		else
			outputFileName = [outputFileName stringByAppendingString:@"-"];
        
		
		outputFileName = [outputFileName stringByAppendingString:[[NSNumber numberWithInt:i]stringValue]];
		outputFileName = [outputFileName stringByAppendingString:@"-"];
		outputFileName = [outputFileName stringByAppendingString:[[m3uArray objectAtIndex:i] valueForKey:@"trackTitle"]];
		outputFileName = [outputFileName stringByAppendingString:@".wav"];
		
		/* INIT KSSPLAY */
		if((kss=KSS_load_file(fileNameC))== NULL)
		{
            fprintf(stderr,"FILE READ ERROR!\n") ;
            exit(1) ;
		}
		
		KSSPLAY_set_data(kssplay, kss) ;
		KSSPLAY_reset(kssplay, [[[m3uArray objectAtIndex:i] valueForKey:@"trackNumber"] intValue], 0) ;
        
		// 1 = droite ; 2 = gauche ; 3 = centre
		for(k=0;k<13;k++)
		{
			KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,k,opllPan[k]);
		}
		
		KSSPLAY_set_device_volume(kssplay,EDSC_PSG,psgVolume);
		KSSPLAY_set_device_volume(kssplay,EDSC_SCC,sccVolume);
		KSSPLAY_set_device_volume(kssplay,EDSC_OPL,oplVolume);
		KSSPLAY_set_device_volume(kssplay,EDSC_OPLL,opllVolume);
		KSSPLAY_set_master_volume(kssplay,masterVolume);
		
		KSSPLAY_set_channel_mask(kssplay,EDSC_PSG,psgMask);
		KSSPLAY_set_channel_mask(kssplay,EDSC_SCC,sccMask);
		KSSPLAY_set_channel_mask(kssplay,EDSC_OPL,oplMask);
		KSSPLAY_set_channel_mask(kssplay,EDSC_OPLL,opllMask);
        
        // prepare the format
        AudioStreamBasicDescription asbd;
        
        memset(&asbd, 0, sizeof(asbd));
        
        
        asbd.mSampleRate = frequency;
        asbd.mFormatID = kAudioFormatLinearPCM;
        asbd.mBytesPerPacket = 4;
        asbd.mFramesPerPacket = 1;
        asbd.mBytesPerFrame = 4;
        asbd.mChannelsPerFrame = 2;
        asbd.mBitsPerChannel = 16;
        asbd.mReserved = 0;
        asbd.mFormatFlags = kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
        
        // set up the file
        AudioFileID audioFile;
        OSStatus audioErr = noErr;
        NSURL *fileURL = [NSURL fileURLWithPath:outputFileName];
        
        AudioFileCreateWithURL((__bridge CFURLRef)fileURL,
                               kAudioFileWAVEType,
                               &asbd,
                               kAudioFileFlags_EraseFile,
                               &audioFile);
        
        assert(audioErr == noErr);
        
        SInt64 position = 0;
        // Ici on calcule le son d'un seul coup.
        
		for(j=0;j<[[[m3uArray objectAtIndex:i] valueForKey:@"trackDuration"] intValue];j++)
		{
			if(!_isPlaying)
			{
                dispatch_async(dispatch_get_main_queue(),^ {
				[progressbarOutlet setDoubleValue:0];
                });
				return;
			//	[localPool release];
			}
            calculationTime++;
            dispatch_async(dispatch_get_main_queue(),^ {
            [progressbarOutlet setDoubleValue:calculationTime];
            });
			// ici generer le wave et le sauver dans le fichier.
            KSSPLAY_calc(kssplay, wavebuf, frequency) ;
            
            UInt32 ioNumBytes = (UInt32)sizeof(wavebuf);
            
            audioErr = AudioFileWriteBytes(audioFile, false,  position, &ioNumBytes, wavebuf);
            position += frequency*4;
		}
     
        
      
		audioErr= AudioFileClose(audioFile);
        
		
		// ici fermer le fichier wave
	}
    dispatch_async(dispatch_get_main_queue(),^ {
	[progressbarOutlet setDoubleValue:0];
    
	_isPlaying = NO;
    
    //NSLog(@"Export terminé");
        
	[cancelButtonOutlet setEnabled:NO];
	[exportButtonOutlet setEnabled:YES];
    });
    //[localPool release];
}

- (IBAction)selectDestinationFolder:(id)sender
{
    // Create the File Open Dialog class.
	NSSavePanel* saveDlg = [NSSavePanel savePanel];
	[saveDlg setCanCreateDirectories:YES];
    
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [saveDlg runModal] == NSModalResponseOK )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
        
        NSURL *names;
		
		names = [saveDlg URL];
        
		kssFileName = [names path];
        [kssFileName retain];
		
		// Loop through all the files and process them.
        // NSString* fileName = [saveDlg directory];
        dispatch_async(dispatch_get_main_queue(),^ {
		[destinationTextFieldOutlet setStringValue:kssFileName];
		targetFolderName = [destinationTextFieldOutlet stringValue];
		destFolderChoosen = 1;
		if ((destFolderChoosen) && (sourceFileChoosen))
		{
			[exportButtonOutlet setEnabled:YES];
		}
        });
	}
}

- (IBAction)selectM3u:(id)sender
{
	NSOpenPanel	*op = [NSOpenPanel openPanel];
	//NSArray	*names;
	NSString *m3uFile;
	NSString *m3uPath;
	
	totalPlayTime = 0;
    
    [op setAllowedFileTypes:[NSArray arrayWithObjects: @"m3u",@"k3u", nil]];
    if([op runModal])
	{
        NSURL *myURL;
		
		myURL = [op URL];
        
		m3uFile = [myURL path];
        
        
        
		m3uPath = [m3uFile stringByDeletingLastPathComponent];
		m3uPath = [m3uPath stringByAppendingString:@"/"];
        
        //	myM3uObject = [[m3uObject alloc] init];
        
		m3uArray = [[NSMutableArray alloc] init];
		m3uParser *myParser = [[m3uParser alloc] init];
        
		m3uArray = [myParser parseM3uFile:m3uFile];
        for(int i=0; i< [m3uArray count] ; i++)
        {
            totalPlayTime = totalPlayTime + [[[m3uArray objectAtIndex:i] valueForKey:@"trackDuration"] intValue];
        }
        
        		[myParser release];
        
		[playlistTextFieldOutlet setStringValue:m3uFile];
		
		sourceFileChoosen = 1;
		if ((destFolderChoosen) && (sourceFileChoosen))
		{
			[exportButtonOutlet setEnabled:YES];
		}
	}
}

@end
