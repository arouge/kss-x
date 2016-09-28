#import "kssObject.h"

static id _sharedInstance; 

@implementation kssObject

+(id)sharedInstance { 
    if (!_sharedInstance) 
        _sharedInstance = [[[self class] alloc] init]; 
    
    return _sharedInstance; 
} 

- (id) init { 
    if (_sharedInstance) { 
        [self dealloc];
        self = [_sharedInstance retain];
    } else { 
        self = [super init]; 
        if (self != nil) { 
			
		}
        _sharedInstance = self; 
    }
	
	return self; 
} 

-(NSNumber *)defaultPlayTime
{
    return m_defaultPlayTime;
}

- (void)setDefaultPlayTime:(NSNumber *)defaultPlayTime
{
    [m_defaultPlayTime release];
    m_defaultPlayTime = [defaultPlayTime copy];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    #define playTimeKey @"playTime"
    
    [defaults setObject:m_defaultPlayTime forKey:playTimeKey];
}


-(NSNumber *)sccMask
{
	return m_sccMask;
}

-(NSNumber *)psgMask
{
	return m_psgMask;
}


-(void)setPsgMask:(NSNumber *)psgMask
{
	[m_psgMask release];
	m_psgMask = [psgMask copy];	

	[self applyKssSettings];

}

-(void)setSccMask:(NSNumber *)sccMask
{
	[m_sccMask release];
	m_sccMask = [sccMask copy];
	[self applyKssSettings];
}

-(void)setOplMask:(NSNumber *)oplMask
{
	[m_oplMask release];
	m_oplMask = [oplMask copy];
	[self applyKssSettings];

}

-(void)setOpllMask:(NSNumber *)opllMask
{
	[m_opllMask release];
	m_opllMask = [opllMask copy];
	[self applyKssSettings];

}

- (NSNumber *)fileOpen
{
	return m_fileOpen;
}

- (void)setFileOpen:(NSNumber *)status
{
	m_fileOpen = [status copy];
}

- (NSString *)kssFile
{
	return m_kssFile;
}


- (BOOL)setKssFile:(NSString *)kssFile
{
	NSNotificationCenter *nc;
    
	char fileNameC[256];
	
	nc = [NSNotificationCenter defaultCenter];

	NSString *driverPath;
	
		shouldReadNote = false;
	
	songShouldChange = true;
	loadMgs = TRUE;
	loadKinrou = TRUE;
	loadMpk = TRUE;
	loadMpk103 = TRUE;
	loadOpx = TRUE;
	loadMbm = TRUE;
	loadFmPac = TRUE;

	if(loadFmPac)
	{
        driverPath = [[NSBundle mainBundle] pathForResource:@"fmpac" ofType:@"rom"];
		KSS_load_fmbios([driverPath UTF8String]);
	}

	if(loadMgs)
	{
		driverPath = [[NSBundle mainBundle] pathForResource:@"mgsdrv" ofType:@"com"];		
		KSS_load_mgsdrv([driverPath UTF8String]);
	}

	if(loadKinrou)
	{
		driverPath = [[NSBundle mainBundle] pathForResource:@"kinrou5" ofType:@"drv"];			
		KSS_load_kinrou([driverPath UTF8String]);
	}
	
	if(loadMpk)
	{
		driverPath = [[NSBundle mainBundle] pathForResource:@"mpk" ofType:@"bin"];		
		KSS_load_mpk106([driverPath UTF8String]);
	}
	
	if(loadMpk103)
	{
		driverPath = [[NSBundle mainBundle] pathForResource:@"mpk103" ofType:@"bin"];		
		KSS_load_mpk103([driverPath UTF8String]);
	}
	
	if(loadOpx)
	{
		driverPath = [[NSBundle mainBundle] pathForResource:@"opx4kss" ofType:@"bin"];		
		KSS_load_opxdrv([driverPath UTF8String]);
	}
	
	if(loadMbm)
	{
		driverPath = [[NSBundle mainBundle] pathForResource:@"mbr143" ofType:@"001"];
		KSS_load_mbmdrv([driverPath UTF8String]);

	}

	if(![kssFile isEqual:m_kssFile])
	{

		(void)strncpy(fileNameC,[kssFile UTF8String], sizeof(fileNameC));
		[m_kssFile release];
		m_kssFile = [kssFile copy];
		if((kss=KSS_load_file(fileNameC))==NULL)
		{	
			[m_kssFile release];
			m_kssFile = [kssFile copy];
			[nc postNotificationName:@"songFileChanged" object:nil];

			return(0);
		}
		else
		{

			[m_kssFile release];
			m_kssFile = [kssFile copy];
			
			[nc postNotificationName:@"songFileChanged" object:nil];

			[self updateKss:1];

			return(1);			
		}

	}
	else 
	{
		if([m_fileOpen intValue])
		{	
			return(1);
		}
		else return(0);
	}
}

-(int)shouldReadNotes
{
	return shouldReadNote;	
}
-(NSNumber *)size
{
	return [NSNumber numberWithInt:kss->init_adr];
}

-(NSNumber *)masterVolume
{
	return m_masterVolume;
}

-(BOOL)isRunning
{
	return [m_OutputUnit isRunning];
}

-(NSString *)m3uFileLocation
{
	return m_m3uFileLocation;
}

-(void)setm3uFileLocation:(NSString *)filePath type:(NSString *)typeName
{
	[m_m3uFileLocation release];
	m_m3uFileLocation = [filePath copy];
}

-(void)fileDraged:(NSString *)filePath type:(NSString *)typeName
{
	NSNotificationCenter *nc;
    
	[m_m3uFileLocation release];
	m_m3uFileLocation = [filePath copy];

	nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"dragedFile" object:nil];
}

-(void)changeMasterVolume:(NSNumber *)masterVolume
{
	#define preferencesMasterVolume @"masterVolume"

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	
	[defaults setObject:masterVolume forKey:preferencesMasterVolume];
	m_masterVolume = [masterVolume copy];
	//nc = [NSNotificationCenter defaultCenter];
	[self applyKssSettings];
	//NSLog(@"%i", [masterVolume intValue]);

	//[nc postNotificationName:@"volumeChanged" object:nil];
}

-(void)changeSccVolume:(NSNumber *)sccVolume
{
	#define sccVolumeKey @"sccVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:sccVolume forKey:sccVolumeKey];


	m_sccVolume = [sccVolume copy];

//	nc = [NSNotificationCenter defaultCenter];
	[self applyKssSettings];

	//[nc postNotificationName:@"volumeChanged" object:nil];
}

-(void)changeOplVolume:(NSNumber *)oplVolume
{
#define oplVolumeKey @"oplVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:oplVolume forKey:oplVolumeKey];
	
	
	m_oplVolume = [oplVolume copy];
//	nc = [NSNotificationCenter defaultCenter];
	[self applyKssSettings];

	//[nc postNotificationName:@"volumeChanged" object:nil];
}

-(void)changeOpllVolume:(NSNumber *)opllVolume
{
#define opllVolumeKey @"opllVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:opllVolume forKey:opllVolumeKey];
	
//	NSNotificationCenter *nc;

	m_opllVolume = [opllVolume copy];
//	nc = [NSNotificationCenter defaultCenter];
	[self applyKssSettings];

	//[nc postNotificationName:@"volumeChanged" object:nil];
}

-(void)changePsgVolume:(NSNumber *)psgVolume
{
#define psgVolumeKey @"psgVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:psgVolume forKey:psgVolumeKey];
	
//	NSNotificationCenter *nc;
	m_psgVolume = [psgVolume copy];

//	nc = [NSNotificationCenter defaultCenter];
	[self applyKssSettings];

	//[nc postNotificationName:@"volumeChanged" object:nil];
}

-(NSNumber *)psgVolume
{
 return m_psgVolume;
}

-(NSNumber *)sccVolume
{
 return m_sccVolume;
}

-(NSNumber *)oplVolume
{
 return m_oplVolume;
}

-(NSNumber *)opllVolume
{
 return m_opllVolume;
}

- (NSNumber *)frameRate
{
	return m_frameRate;
}

- (void)setCpuSpeed:(NSNumber *)cpuSpeed
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[m_cpuSpeed release];
	m_cpuSpeed = [cpuSpeed copy];

	songShouldChange=1;
	#define cpuKey @"cpuSpeed"
	
	[defaults setObject:cpuSpeed forKey:cpuKey];
}

-(NSNumber *)getCpuSpeed
{
	return m_cpuSpeed;
}

- (void)setVdpSpeed:(NSNumber *)vdpSpeed
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[m_vdpSpeed release];
	m_vdpSpeed = [vdpSpeed copy];
	songShouldChange=1;
	#define vdpKey @"vdpSpeed"
	
	[defaults setObject:vdpSpeed forKey:vdpKey];
}

- (NSNumber *)getVdpSpeed
{
	return m_vdpSpeed;
}

- (void)setFrameRate:(NSNumber *)frameRate
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[self pause];
	[m_frameRate release];
	m_frameRate = [frameRate copy];
	myAudioProperty.mSampleRate = [m_frameRate intValue];
	returnedValue = [m_OutputUnit setDesiredFormat:myAudioProperty];

	[self updateKss:1];
	[self play];
	
	#define frameRateKey @"frameRate"
	
	[defaults setObject:m_frameRate forKey:frameRateKey];
}

- (NSNumber *)songNumber
{
	return m_songNumber;
}

- (void)setSongNumber:(NSNumber *)songNumber
{
	songShouldChange = false;
	[m_songNumber release];
	m_songNumber = [songNumber copy];	

	songShouldChange = true;
//	[self updateKss:0];	
}

- (NSNumber *)playTime
{
	return m_playTime;
}

- (void)setPlayTime:(NSNumber *)playTime
{
	[m_playTime release];
	m_playTime = [playTime copy];
}


- (NSNumber *)bufferSize
{
	return m_bufferSize;
}


- (void)setBufferSize:(NSNumber *)bufferSize
{
	[m_bufferSize release];
	m_bufferSize = [bufferSize copy];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	#define bufferKey @"bufferSize"
	
	[defaults setObject:m_bufferSize forKey:bufferKey];
}

-(void)setOpllPan:(NSNumber *)channel value:(NSNumber *)value
{
	int i=[channel intValue];
    int pan;
    // 1 = droite ; 2 = gauche ; 3 = centre

    if([value intValue]==0)
        pan = 1;
    if([value intValue]==1)
        pan = 3;
    if([value intValue]==2)
        pan = 2;
    
	opllPan[i] = pan;
	[self applyKssSettings];
}



- (void)updateKss:(BOOL)total // Create KSS stuff
{	
	songShouldChange = false;	
	shouldReadNote = false;
	if([m_OutputUnit isRunning])
	{
		[self togglePause];
	}
    
    if(total)
    kssplay = KSSPLAY_new([m_frameRate intValue], 2, 16, [m_cpuSpeed intValue]) ; 
	KSSPLAY_set_device_quality(kssplay,EDSC_PSG,YES);
	KSSPLAY_set_device_quality(kssplay,EDSC_SCC,YES);
	KSSPLAY_set_device_quality(kssplay,EDSC_OPL,YES);
	KSSPLAY_set_device_quality(kssplay,EDSC_OPLL,YES);

	kssplay->opll_stereo = 1;
	kssplay->vm->cpu_speed = [m_cpuSpeed intValue];

	if([m_fileOpen intValue])
	{
		// INIT KSSPLAY 
		KSSPLAY_set_data(kssplay, kss) ;
        if([m_vdpSpeed intValue] == 0)
        {
            kssplay->vsync_freq = kssplay->kss->pal_mode?50:60;
        }
        else
        kssplay->vsync_freq = [m_vdpSpeed intValue];
        
		KSSPLAY_reset(kssplay, [m_songNumber intValue], [m_cpuSpeed intValue]) ;
		shouldReadNote = true;
	}	
	
	m_playTime = [NSNumber numberWithInt:0];
	[self setPlayTime:[NSNumber numberWithInt:0]]; 
	framePlayed = 0;
	
	if(![m_OutputUnit isRunning])
	{
		[self togglePause];
	}
    [self applyKssSettings];

}

-(NSDate *)startTime
{
	return m_startTime;
}

- (void)createAudio // Create and start Audio
{
	shortMax = 1.0f / ((float) 0x7fff);
	m_moreToDo = true;
	
	//threadLock = [[NSLock alloc] init];
	
	
	m_OutputUnit = [[CAOutputUnit alloc] init];
	
	myAudioProperty.mChannelsPerFrame = 2;
    myAudioProperty.mBitsPerChannel = 32;
    myAudioProperty.mBytesPerFrame = 4;
    myAudioProperty.mBytesPerPacket = 4;
	
	#ifdef __BIG_ENDIAN__
		myAudioProperty.mFormatFlags = kLinearPCMFormatFlagIsFloat | kAudioFormatFlagIsBigEndian | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
	#else
       myAudioProperty.mFormatFlags = kLinearPCMFormatFlagIsFloat | kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
	#endif
	
	myAudioProperty.mFormatID = kAudioFormatLinearPCM;
    myAudioProperty.mFramesPerPacket = 1;
    myAudioProperty.mSampleRate = [m_frameRate intValue];
	
	returnedValue = [m_OutputUnit setDesiredFormat:myAudioProperty];
    [m_OutputUnit setDelegate:self];
	
	[m_OutputUnit start];
	opllPan[0] = 3; opllPan[1] = 3;
	opllPan[2] = 3; opllPan[3] = 3;
	opllPan[4] = 3; opllPan[5] = 3;
	opllPan[6] = 3; opllPan[7] = 3;
	opllPan[8] = 3; opllPan[9] = 3;
	opllPan[10] = 3; opllPan[11] = 3;
	opllPan[12] = 3; opllPan[13] = 3;
	intPsgPan = 3;
	intSccPan = 3;
	intOplPan = 3;
	intOpllPan = 3;
	
	//		opll_pan0=3; opll_pan1=3; opll_pan2=3; opll_pan3=3; opll_pan4=3; opll_pan5=3; opll_pan6=3; opll_pan7=3;
	//		opll_pan8=3; opll_pan9=3; opll_pan10=3; opll_pan11=3; opll_pan12=3; opll_pan13=3;
	m_fileOpen = [NSNumber numberWithInt:0];
	
}
-(void)play
{
	[m_OutputUnit start];
}

-(void)pause
{
	[m_OutputUnit stop];
}

-(void)togglePause
{
    if([m_OutputUnit isRunning])
       [m_OutputUnit stop];
    else
        [m_OutputUnit start];
}

- (void)resetSong
{
	int i=0;
	for(i=0;i<=MAX_RATE*2;i++)
	{
		shortBuffer[0][i]=0;
		shortBuffer[1][i]=0;
	}
}

-(void)setMoreToDo:(NSNumber *)value
{
	m_moreToDo = [value intValue];
}

-(NSNumber *)moreToDo
{
	return [NSNumber numberWithInt:m_moreToDo];
}

-(void)setFadeOutTime:(int)fadeTime
{
	fadeOutTime = fadeTime;
}

- (void)setSongTime:(int)songTime
{
	m_songTime = songTime;
}

-(void)applyKssSettings
{
	if([[self fileOpen] intValue])
	{

	 KSSPLAY_set_device_volume(kssplay,EDSC_PSG,[m_psgVolume intValue]);
	 KSSPLAY_set_device_volume(kssplay,EDSC_SCC,[m_sccVolume intValue]);
	 KSSPLAY_set_device_volume(kssplay,EDSC_OPL,[m_oplVolume intValue]);
	 KSSPLAY_set_device_volume(kssplay,EDSC_OPLL,[m_opllVolume intValue]);
	
	 KSSPLAY_set_master_volume(kssplay,[m_masterVolume intValue]);
	
	 #define PSG_MASK_CH(x) (1<<(x))
		
	 KSSPLAY_set_channel_mask(kssplay,EDSC_PSG,[m_psgMask intValue]);
	 KSSPLAY_set_channel_mask(kssplay,EDSC_SCC,[m_sccMask intValue]);
	 KSSPLAY_set_channel_mask(kssplay,EDSC_OPL,[m_oplMask intValue]);
	 KSSPLAY_set_channel_mask(kssplay,EDSC_OPLL,[m_opllMask intValue]);
	 
	 KSSPLAY_set_device_pan(kssplay,EDSC_PSG,2);
	 KSSPLAY_set_device_pan(kssplay,EDSC_SCC,3);
	 KSSPLAY_set_device_pan(kssplay,EDSC_OPL,5);
	 KSSPLAY_set_device_pan(kssplay,EDSC_OPLL,9);
	 
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,0,opllPan[0]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,1,opllPan[1]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,2,opllPan[2]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,3,opllPan[3]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,4,opllPan[4]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,5,opllPan[5]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,6,opllPan[6]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,7,opllPan[7]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,8,opllPan[8]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,9,opllPan[9]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,10,opllPan[10]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,11,opllPan[11]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,12,opllPan[12]);
	 KSSPLAY_set_channel_pan(kssplay,EDSC_OPLL,13,opllPan[13]);
		
	}
}

-(KMZ80_CONTEXT)context
{
    return kssplay->vm->context;
}

-(OPL *)opl
{
    return kssplay->vm->opl;
}

-(SNG *)sng
{
    return kssplay->vm->sng;
}

-(OPLL *)opll
{
    return kssplay->vm->opll;
}

-(SCC *)scc
{
    return kssplay->vm->scc;
}

-(PSG *)psg
{
    return kssplay->vm->psg;
}
		   
- (id)generateBuffer
{	
 //   NSAutoreleasePool * localPool = [[NSAutoreleasePool alloc] init];
	NSLock *threadLock;

	threadLock = [[NSLock alloc] init];
	
	[threadLock lock];
	

	if(songShouldChange)
	{
		[self updateKss:1];
		songShouldChange=false;
	}

	if(framePlayed >= [[self frameRate] intValue])
	{
		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		
		framePlayed = framePlayed - [[self frameRate] intValue];
		[self setPlayTime:[NSNumber numberWithInt:[[self playTime] intValue]+1]];
		[nc postNotificationName:@"timeChanged" object:nil];
	}
	
	
		KSSPLAY_calc(kssplay, shortBuffer[whichBuffer], [[self bufferSize] intValue]) ;
		framePlayed = framePlayed + [[self bufferSize] intValue];
	
	
	NSNotificationCenter *midinc;
    midinc = [NSNotificationCenter defaultCenter];
    [midinc postNotificationName:@"newNotes" object:nil];

	[threadLock unlock];
    [threadLock release];
	
	return 0;

}

- (void)outputUnit:(CAOutputUnit *)outputUnit requestFrames:(UInt32)frames data:(AudioBufferList *)data flags:(AudioUnitRenderActionFlags *)flags timeStamp:(const AudioTimeStamp *)timeStamp;
{
 //   NSAutoreleasePool * localPool = [[NSAutoreleasePool alloc] init];
    int i = 0 ,j = 0;
    float *bufferLeft, *bufferRight;
	
	bufferLeft = (float *)(data->mBuffers[0].mData);
	bufferRight = (float *)(data->mBuffers[1].mData);

	for (j = 0; j < data->mBuffers[i].mDataByteSize/4; j ++)
	{
		
        bufferRight[j] = ((float)shortBuffer[!whichBuffer][position]) * shortMax;
		bufferLeft[j] = ((float)shortBuffer[!whichBuffer][position+1]) * shortMax;

		if(position>=(([[self bufferSize] intValue]*2)-2))		{
			position = 0;
         
            whichBuffer=!whichBuffer;
            
            [NSThread detachNewThreadSelector:@selector(generateBuffer) toTarget:self withObject:nil];	
		}
		
		position=position+2;
	}

//	[localPool release];

} 
-(NSNumber *)getPsgVolume
{
   return m_psgVolume;
}

-(NSNumber *)getPsgMask
{
   return m_psgMask;
}

-(NSNumber *)getSccVolume
{
   return m_sccVolume;
}

-(NSNumber *)getSccMask
{
   return m_sccMask;
}

-(NSNumber *)getOplVolume
{
   return m_oplVolume;
}

-(NSNumber *)getOplMask
{
   return m_oplMask;
}

-(NSNumber *)getOpllVolume
{
   return m_opllVolume;
}

-(NSNumber *)getOpllMask
{
   return m_opllMask;
}

-(NSNumber *)getOpllPan:(NSNumber *)channelNumber
{
   int i;
   i = [channelNumber intValue];
   
   return [NSNumber numberWithInt:opllPan[i]];
}

-(NSNumber *)getMasterVolume
{
	return m_masterVolume;
}

-(void)setPsgPan:(NSNumber *)psgPan
{
   intPsgPan = [psgPan intValue];
}

-(void)setSCCPan:(NSNumber *)sccPan
{
   intSccPan = [sccPan intValue];
}

-(void)setOplPan:(NSNumber *)oplPan
{
   intOplPan = [oplPan intValue];
}

-(void)setOpllPan:(NSNumber *)oplllPan
{
   intOpllPan = [oplllPan intValue];
}


@end
