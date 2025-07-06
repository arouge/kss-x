#import "mainMenu.h"
#import "aboutWindow.h"
#import "kssPlayer.h"
#import "mixerController.h"
#import "preferencesController.h"
#import "devicesController.h"
#import "exportwave.h"
#import "psgMidi.h"
#import "sccMidi.h"
#import "opllMidi.h"

@implementation mainMenu

- (int) aleatoire:(int)min maximum:(int)max
{
    int value;
    time_t t1;
    do
    {
        t1=clock();
        value=(int)rand()*t1/10000000;
    }while (value < min || value > max);
    return value;    
}

- (IBAction)volumeLow:(id)sender
{
	NSNotificationCenter *nc;

	if([myKSS masterVolume]<=-255)
	{
		[myKSS changeMasterVolume:-255];
	}
	else
	{	
		[myKSS changeMasterVolume: [myKSS masterVolume]-5];
	}
	
	nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"songFileChanged" object:nil];
}

- (IBAction)volumeHigh:(id)sender
{
	NSNotificationCenter *nc;

	if([myKSS masterVolume]>=50)
	{
		[myKSS changeMasterVolume:50];
	}
	else
	{	
		[myKSS changeMasterVolume:[myKSS masterVolume]+5];
	}
	
	nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"songFileChanged" object:nil];
}

- (IBAction)miniPlayerNextTen:(id)sender
{
}

- (IBAction)miniPlayerPreviousTen:(id)sender
{
	[myKSS setSongNumber:[myKSS songNumber]-10];
}

-(IBAction)replaySong:(id)sender
{
	[myKSS setSongNumber:[myKSS songNumber]];
}

- (IBAction)miniPlayerOpenKSS:(id)sender
{
    [_playerController openM3u:self];
}

- (void)awakeFromNib
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger prefVdpSpeed = [defaults integerForKey:vdpKey];
    NSInteger prefFramRate = [defaults integerForKey:frameRateKey];
    NSInteger prefBufferSize = [defaults integerForKey:bufferKey];
    NSInteger prefCpuSpeed = [defaults integerForKey:cpuKey];
    NSInteger prefMasterVolume = [defaults integerForKey:masterVolumeKey];
    NSInteger psgVolume = [defaults integerForKey:psgVolumeKey];
    NSInteger sccVolume = [defaults integerForKey:sccVolumeKey];
    NSInteger oplVolume = [defaults integerForKey:oplVolumeKey];
    NSInteger opllVolume = [defaults integerForKey:opllVolumeKey];
    NSInteger defaultPlayTime = [defaults integerForKey:playTimeKey];
    NSInteger prefPsgMask = [defaults integerForKey:@"psgMask"];
    NSInteger prefSccMask = [defaults integerForKey:@"sccMask"];
    NSInteger prefOplMask = [defaults integerForKey:@"oplMask"];
    NSInteger prefOpllMask = [defaults integerForKey:@"opllMask"];

	if (!prefVdpSpeed) prefVdpSpeed = 0;
	[defaults setInteger:prefVdpSpeed forKey:vdpKey];
	 
	if (!prefFramRate) prefFramRate = 44100;
	[defaults setInteger:prefFramRate forKey:frameRateKey];

	if (!prefBufferSize) prefBufferSize = 8;
	[defaults setInteger:prefBufferSize forKey:bufferKey];
	
	
	if (!prefCpuSpeed) prefCpuSpeed = 0;
	[defaults setInteger:prefCpuSpeed forKey:cpuKey];

	if (!prefMasterVolume)  prefMasterVolume = 0;
	[defaults setInteger:prefMasterVolume forKey:masterVolumeKey];
	
	if (!psgVolume)  psgVolume = 0;
	[defaults setInteger:psgVolume forKey:psgVolumeKey];
	
	if (!sccVolume)  sccVolume = 0;
	[defaults setInteger:sccVolume forKey:sccVolumeKey];
	
	if (!oplVolume)  oplVolume = 0;
	[defaults setInteger:oplVolume forKey:oplVolumeKey];
	
	if (!opllVolume)  opllVolume = 0;
	[defaults setInteger:opllVolume forKey:opllVolumeKey];
    
    if (!defaultPlayTime)  defaultPlayTime = 90;
    [defaults setInteger:defaultPlayTime forKey:playTimeKey];
    
    [defaults setInteger:prefPsgMask forKey:@"psgMask"];
    [defaults setInteger:prefSccMask forKey:@"sccMask"];
    [defaults setInteger:prefOplMask forKey:@"oplMask"];
    [defaults setInteger:prefOpllMask forKey:@"opllMask"];

	//remoteControl = [[AppleRemote alloc] initWithDelegate: self];

	//[remoteControl startListening: self];
	
	myKSS = [[kssObject alloc] init];
	
	[myKSS createAudio]; // Create Audio Stuff.

	[myKSS setSongNumber:0];
	[myKSS setVdpSpeed:prefVdpSpeed];

    [myKSS setFrameRate:44100];
    [myKSS setBufferSize:735];

    [myKSS setCpuSpeed:prefCpuSpeed];
    [myKSS setDefaultPlayTime:defaultPlayTime];
    
	[myKSS changeMasterVolume:prefMasterVolume];
	[myKSS changePsgVolume:psgVolume];
	[myKSS changeSccVolume:sccVolume];
	[myKSS changeOplVolume:oplVolume];
	[myKSS changeOpllVolume:opllVolume];
    [myKSS setPsgMask:prefPsgMask];
    [myKSS setSccMask:prefSccMask];
    [myKSS setOplMask:prefOplMask];
    [myKSS setOpllMask:prefOpllMask];
	[myKSS pause];
	
	[self displayPlayer:self];

}

- (IBAction)displayOpllMidi:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        if (_opllMidi == nil)
        {
            _opllMidi = [[opllMidi alloc] initWithWindowNibName:@"opllMidi"];
        }
        
        if([[_opllMidi window] isVisible])
        {
            [[_opllMidi window] close];
        }
        else
        {
            [_opllMidi showWindow:self];
        }
    });
}

- (IBAction)displayPsgMidi:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {

        if (_psgMidi == nil)
        {
            _psgMidi = [[psgMidi alloc] initWithWindowNibName:@"psgMidi"];
        }
        
        if([[_psgMidi window] isVisible])
        {
            [[_psgMidi window] close];
        }
        else
        {
            [_psgMidi showWindow:self];
        }
    });
}

- (IBAction)displaySccMidi:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
        
        if (_sccMidi == nil)
        {
            _sccMidi = [[sccMidi alloc] initWithWindowNibName:@"sccMidi"];
        }
       
        if([[_sccMidi window] isVisible])
        {
            [[_sccMidi window] close];
        }
        
        else
        {
            [_sccMidi showWindow:self];
        }
       
    });
}

- (IBAction)displayAboutBox:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
    if (_aboutController == nil)
    {
        _aboutController = [[aboutWindow alloc] initWithWindowNibName:@"aboutController"]; 
    }
    [_aboutController showWindow:self];
    });
}

- (IBAction)displayPlayer:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^
    {
        if (_playerController == nil)
        {
            _playerController = [[kssPlayer alloc] initWithWindowNibName:@"kssPlayer"];
            [myKSS  setPlayerAddress:_playerController];

            [[_playerController window] close];
        }
        if([[_playerController window] isVisible])
        {
            [[_playerController window] close];
        }
        else
        {
            [_playerController showWindow:self];
        }
    });
    

}

- (IBAction)displayMixer:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
    if (_mixController == nil)
    {
        _mixController = [[mixerController alloc] initWithWindowNibName:@"mixerController"]; 
    }
	if([[_mixController window] isVisible])
	{ 
		[[_mixController window] close];
	}
	else
	{
		[_mixController showWindow:self];
	}
    });
}

- (IBAction)displayPreferencesWindow:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
    if (_prefController == nil)
    {
       _prefController = [[preferencesController alloc] initWithWindowNibName:@"preferences"]; 
    }
	
    [_prefController showWindow:self];
    });
}

- (IBAction)displayDevices:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
    if (_devController == nil)
	{
        _devController = [[devicesController alloc] initWithWindowNibName:@"devicesController"]; 
    }
	if([[_devController window] isVisible])
	{ 
		[[_devController window] close];
	}
	else
	{
		[_devController showWindow:self];
	}
    });
}

- (IBAction)displayExport:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
	if (_exportwave == nil)
	{
        _exportwave = [[exportwave alloc] initWithWindowNibName:@"export"]; 
	}
	
	if([[_exportwave window] isVisible])
	{ 
		[[_exportwave window] close];
	}
	else
	{
		[_exportwave showWindow:self];
	}
    });
}

- (IBAction)miniPlayerNext:(id)sender
{	
	[_playerController next:sender];	
}

- (IBAction)miniPlayerPrevious:(id)sender
{
	[_playerController previous:sender];
}

- (BOOL)application:NSApp openFile:(NSString *)filename {
    [myKSS setm3uFileLocation:filename type:[filename pathExtension]];
    [_playerController openFile];
    
     return TRUE;
}
	
@end

