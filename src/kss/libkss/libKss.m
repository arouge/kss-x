#import "libKss.h"

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
        kssplay = KSSPLAY_new((int)m_frameRate, 2, 16) ;

        if (self != nil) {
            
        }
        _sharedInstance = self;
    }
    
    return self;
} 
-(void)applyKssSettings
{
    if([self fileOpen])
    {

     KSSPLAY_set_device_volume(kssplay,EDSC_PSG,(int)m_psgVolume);
     KSSPLAY_set_device_volume(kssplay,EDSC_SCC,(int)m_sccVolume);
     KSSPLAY_set_device_volume(kssplay,EDSC_OPL,(int)m_oplVolume);
     KSSPLAY_set_device_volume(kssplay,EDSC_OPLL,(int)m_opllVolume);
    
     KSSPLAY_set_master_volume(kssplay,(int)m_masterVolume);
    
     #define PSG_MASK_CH(x) (1<<(x))
        
     KSSPLAY_set_channel_mask(kssplay,EDSC_PSG,(int)m_psgMask);
     KSSPLAY_set_channel_mask(kssplay,EDSC_SCC,(int)m_sccMask);
     KSSPLAY_set_channel_mask(kssplay,EDSC_OPL,(int)m_oplMask);
     KSSPLAY_set_channel_mask(kssplay,EDSC_OPLL,(int)m_opllMask);
     
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
-(NSInteger)defaultPlayTime
{
    return m_defaultPlayTime;
}

- (void)setDefaultPlayTime:(NSInteger)defaultPlayTime
{
    m_defaultPlayTime = defaultPlayTime;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    #define playTimeKey @"playTime"
    
    [defaults setInteger:m_defaultPlayTime forKey:playTimeKey];
}


-(NSInteger)sccMask
{
	return m_sccMask;
}

-(NSInteger)psgMask
{
	return m_psgMask;
}


-(void)setPsgMask:(NSInteger)psgMask
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:psgMask forKey:@"psgMask"];

    m_psgMask = psgMask;
    KSSPLAY_set_channel_mask(kssplay,EDSC_PSG,(int)m_psgMask);
}

-(void)setSccMask:(NSInteger)sccMask
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sccMask forKey:@"sccMask"];

	m_sccMask = sccMask;
    KSSPLAY_set_channel_mask(kssplay,EDSC_SCC,(int)m_sccMask);
    
}

-(void)setOplMask:(NSInteger)oplMask
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:oplMask forKey:@"oplMask"];

	m_oplMask = oplMask;
    
    KSSPLAY_set_channel_mask(kssplay,EDSC_OPL,(int)m_oplMask);
}

-(void)setOpllMask:(NSInteger)opllMask
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:opllMask forKey:@"opllMask"];

	m_opllMask = opllMask;
    
    KSSPLAY_set_channel_mask(kssplay,EDSC_OPLL,(int)m_opllMask);}

- (NSInteger)fileOpen
{
	return m_fileOpen;
}

- (void)setFileOpen:(NSInteger)status
{
	m_fileOpen = status;
}

- (NSString *)kssFile
{
	return m_kssFile;
}


- (BOOL)setKssFile:(NSString *)kssFile
{
    
	char fileNameC[256];
	
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
		m_kssFile = [kssFile copy];
		if((kss=KSS_load_file(fileNameC))==NULL)
		{
			m_kssFile = [kssFile copy];
			return(0);
		}
		else
		{

			m_kssFile = [kssFile copy];
			[self updateKss:1];

			return(1);			
		}
	}
	else 
	{
		if(m_fileOpen)
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
-(NSInteger)size
{
	return kss->init_adr;
}

-(NSInteger)masterVolume
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
	m_m3uFileLocation = [filePath copy];
}

-(void)fileDraged:(NSString *)filePath type:(NSString *)typeName
{
	NSNotificationCenter *nc;
    
	m_m3uFileLocation = [filePath copy];

	nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"dragedFile" object:nil];
}

-(void)changeMasterVolume:(NSInteger)masterVolume
{
	#define preferencesMasterVolume @"masterVolume"

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	
	[defaults setInteger:masterVolume forKey:preferencesMasterVolume];
	m_masterVolume = masterVolume;
    KSSPLAY_set_master_volume(kssplay,(int)m_masterVolume);
}

-(void)changeSccVolume:(NSInteger)sccVolume
{
	#define sccVolumeKey @"sccVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:sccVolume forKey:sccVolumeKey];


	m_sccVolume = sccVolume;
    KSSPLAY_set_device_volume(kssplay,EDSC_SCC,(int)m_sccVolume);
       
}

-(void)changeOplVolume:(NSInteger)oplVolume
{
#define oplVolumeKey @"oplVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:oplVolume forKey:oplVolumeKey];
	
	
	m_oplVolume = oplVolume;
    KSSPLAY_set_device_volume(kssplay,EDSC_OPL,(int)m_oplVolume);
}

-(void)changeOpllVolume:(NSInteger)opllVolume
{
#define opllVolumeKey @"opllVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:opllVolume forKey:opllVolumeKey];
	
//	NSNotificationCenter *nc;

	m_opllVolume = opllVolume;
 
       KSSPLAY_set_device_volume(kssplay,EDSC_OPLL,(int)m_opllVolume);
}

-(void)changePsgVolume:(NSInteger)psgVolume
{
#define psgVolumeKey @"psgVolume"
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:psgVolume forKey:psgVolumeKey];
	
//	NSNotificationCenter *nc;
	m_psgVolume = psgVolume;

    KSSPLAY_set_device_volume(kssplay,EDSC_PSG,(int)m_psgVolume);
     
}

-(NSInteger)psgVolume
{
 return m_psgVolume;
}

-(NSInteger)sccVolume
{
 return m_sccVolume;
}

-(NSInteger)oplVolume
{
 return m_oplVolume;
}

-(NSInteger)opllVolume
{
 return m_opllVolume;
}

- (NSInteger)frameRate
{
	return m_frameRate;
}

- (void)setCpuSpeed:(NSInteger)cpuSpeed
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	m_cpuSpeed = cpuSpeed;

	songShouldChange=1;
	#define cpuKey @"cpuSpeed"
	
	[defaults setInteger:cpuSpeed forKey:cpuKey];
}

-(NSInteger)getCpuSpeed
{
	return m_cpuSpeed;
}

- (void)setVdpSpeed:(NSInteger)vdpSpeed
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	m_vdpSpeed = vdpSpeed;
	//songShouldChange=1;
	//#define vdpKey @"vdpSpeed"
    [defaults setInteger:vdpSpeed forKey:@"vdpSpeed"];

    if(m_fileOpen)
    {
        if(m_vdpSpeed == 0)
        {
            kssplay->vsync_freq = kssplay->kss->pal_mode?50:60;
        }
        else
            kssplay->vsync_freq = (int)m_vdpSpeed;
    }
        KSSPLAY_reset(kssplay,(int)m_songNumber,(int)m_cpuSpeed) ;
    
}

- (NSInteger)getVdpSpeed
{
	return m_vdpSpeed;
}

- (void)setFrameRate:(NSInteger )frameRate
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[self pause];
    m_frameRate = frameRate;
	myAudioProperty.mSampleRate = m_frameRate;
	returnedValue = [m_OutputUnit setDesiredFormat:myAudioProperty];

    free(kssplay);
    kssplay = KSSPLAY_new((int)m_frameRate, 2, 16) ;

	[self play];
	
	
	[defaults setInteger:(int)m_frameRate forKey:@"frameRate"];
}

- (NSInteger)songNumber
{
	return m_songNumber;
}

- (void)setSongNumber:(NSInteger)songNumber
{
	songShouldChange = false;
	m_songNumber = songNumber;

	songShouldChange = true;
//	[self updateKss:0];
}

- (NSInteger)playTime
{
	return m_playTime;
}

- (void)setPlayTime:(NSInteger)playTime
{
	m_playTime = playTime;
}


- (NSInteger)bufferSize
{
	return m_bufferSize;
}


- (void)setBufferSize:(NSInteger)bufferSize
{
	m_bufferSize = bufferSize;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	#define bufferKey @"bufferSize"
	
	[defaults setInteger:m_bufferSize forKey:bufferKey];
}

-(void)setOpllPan:(NSInteger)channel value:(NSInteger)value
{
	long i=channel;
    int pan;
    // 1 = droite ; 2 = gauche ; 3 = centre

    if(value==0)
        pan = 1;
    if(value==1)
        pan = 3;
    if(value==2)
        pan = 2;

    opllPan[i] = pan;
    
    KSSPLAY_set_device_pan(kssplay,EDSC_OPLL,3);
    
}

- (void)updateKss:(BOOL)total // Create KSS stuff
{	
	songShouldChange = false;	
	shouldReadNote = false;
	if([m_OutputUnit isRunning])
	{
		[self togglePause];
	}
	kssplay->opll_stereo = 1;

	if(m_fileOpen)
	{
        
		// INIT KSSPLAY 
		KSSPLAY_set_data(kssplay, kss) ;
        if(m_vdpSpeed == 0)
        {
            kssplay->vsync_freq = kssplay->kss->pal_mode?50:60;
        }
        else
        kssplay->vsync_freq = (int)m_vdpSpeed;
        
		KSSPLAY_reset(kssplay,(int)m_songNumber,(int)m_cpuSpeed) ;
		shouldReadNote = true;
       
	}	
	
    m_playTime = 0;
	[self setPlayTime:0];
	framePlayed = 0;
	
	if(![m_OutputUnit isRunning])
	{
		[self togglePause];
	}
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
    myAudioProperty.mSampleRate = m_frameRate;
    
	
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
	m_fileOpen = 0;
	
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

-(void)setMoreToDo:(NSInteger)value
{
	m_moreToDo = value;
}

-(NSInteger)moreToDo
{
	return m_moreToDo;
}

-(void)setFadeOutTime:(int)fadeTime
{
	fadeOutTime = fadeTime;
}

- (void)setSongTime:(int)songTime
{
	m_songTime = songTime;
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
        //[self updateKss:0];
        if(m_fileOpen)
        {
            
            // INIT KSSPLAY
            KSSPLAY_set_data(kssplay, kss) ;
            
            
            KSSPLAY_reset(kssplay,(int)m_songNumber,(int)m_cpuSpeed) ;
            shouldReadNote = true;
           
        }
       ;

        [self setPlayTime:0];
        framePlayed = 0;

		songShouldChange=false;
	}

	if(framePlayed >= [self frameRate])
	{

		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];

		framePlayed = framePlayed - [self frameRate];

		[self setPlayTime:[self playTime]+1];
		[nc postNotificationName:@"timeChanged" object:nil];
	}
	
    [self applyKssSettings];

	KSSPLAY_calc(kssplay, shortBuffer[whichBuffer],(int)[self bufferSize]) ;
    NSNotificationCenter *nc;
    nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"newNotes" object:nil];

    
	framePlayed = framePlayed + [self bufferSize];

	[threadLock unlock];
	
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

		if(position>=(([self bufferSize]*2)-2))		{
			position = 0;
         
            whichBuffer=!whichBuffer;
            
            [NSThread detachNewThreadSelector:@selector(generateBuffer) toTarget:self withObject:nil];	
		}
		
		position=position+2;
	}

//	[localPool release];

} 
-(NSInteger)getPsgVolume
{
   return m_psgVolume;
}

-(NSInteger)getPsgMask
{
   return m_psgMask;
}

-(NSInteger)getSccVolume
{
   return m_sccVolume;
}

-(NSInteger)getSccMask
{
   return m_sccMask;
}

-(NSInteger)getOplVolume
{
   return m_oplVolume;
}

-(NSInteger)oplMask
{
   return m_oplMask;
}

-(NSInteger)getOpllVolume
{
   return m_opllVolume;
}

-(NSInteger)opllMask
{
   return m_opllMask;
}

-(NSInteger)getOpllPan:(NSInteger)channelNumber
{
   int i;
   i = (int)channelNumber;
   
   return opllPan[i];
}

-(NSInteger)getMasterVolume
{
	return m_masterVolume;
}

-(void)setPsgPan:(NSInteger)psgPan
{
   intPsgPan = (int)psgPan;
}

-(void)setSCCPan:(NSInteger)sccPan
{
   intSccPan = (int)sccPan;
}

-(void)setOplPan:(NSInteger)oplPan
{
   intOplPan = (int)oplPan;
}

-(void)setOpllPan:(NSInteger)oplllPan
{
   intOpllPan = (int)oplllPan;
}

-(void)setPlayerAddress:(id)playerAddress
{
    
    m_playerController = playerAddress;
}

@end
