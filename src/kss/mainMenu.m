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
        value=rand()*t1/10000000;
    }while (value < min || value > max);
    return value;    
}


- (IBAction)volumeLow:(id)sender
{
	NSNotificationCenter *nc;

	if([[myKSS masterVolume] intValue]<=-255)
	{
		[myKSS changeMasterVolume:[NSNumber numberWithInt:-255]];
	}
	else
	{	
		[myKSS changeMasterVolume:[NSNumber numberWithInt:[[myKSS masterVolume] intValue]-5]];
	}
	
	nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"songFileChanged" object:nil];
}

- (IBAction)volumeHigh:(id)sender
{
	NSNotificationCenter *nc;

	if([[myKSS masterVolume] intValue]>=50)
	{
		[myKSS changeMasterVolume:[NSNumber numberWithInt:50]];
	}
	else
	{	
		[myKSS changeMasterVolume:[NSNumber numberWithInt:[[myKSS masterVolume] intValue]+5]];
	}
	
	nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:@"songFileChanged" object:nil];
}
/*
- (void)keyDown: (NSEvent *)event
{
	NSString *input = [event characters];
	char test;
	test = [input characterAtIndex:0];
	
	if(test == 3)[self miniPlayerNext:self];
	if(test == 2)[self miniPlayerPrevious:self];
}
*/
- (IBAction)miniPlayerNextTen:(id)sender
{
}

- (IBAction)miniPlayerPreviousTen:(id)sender
{
	[myKSS setSongNumber:[NSNumber numberWithInt:[[myKSS songNumber] intValue]-10]];
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
	NSString *prefVdpSpeed = [defaults stringForKey:vdpKey];
	NSString *prefFramRate = [defaults stringForKey:frameRateKey];
	NSString *prefBufferSize = [defaults stringForKey:bufferKey];
	NSString *prefCpuSpeed = [defaults stringForKey:cpuKey];
	NSString *prefMasterVolume = [defaults stringForKey:masterVolumeKey];
	NSString *psgVolume = [defaults stringForKey:psgVolumeKey];
	NSString *sccVolume = [defaults stringForKey:sccVolumeKey];
	NSString *oplVolume = [defaults stringForKey:oplVolumeKey];
	NSString *opllVolume = [defaults stringForKey:opllVolumeKey];
	NSString *defaultPlayTime = [defaults stringForKey:playTimeKey];
    
	if (prefVdpSpeed == nil) prefVdpSpeed = @"0";
	[defaults setObject:prefVdpSpeed forKey:vdpKey];
	 
	if (prefFramRate == nil) prefFramRate = @"44100";
	[defaults setObject:prefFramRate forKey:frameRateKey];

	if (prefBufferSize == nil) prefBufferSize = @"8";
	[defaults setObject:prefBufferSize forKey:bufferKey];
	
	
	if (prefCpuSpeed == nil) prefCpuSpeed = @"0";
	[defaults setObject:prefCpuSpeed forKey:cpuKey];

	if (prefMasterVolume == nil)  prefMasterVolume = @"0";
	[defaults setObject:prefMasterVolume forKey:masterVolumeKey];
	
	if (psgVolume == nil)  psgVolume = @"0";
	[defaults setObject:psgVolume forKey:psgVolumeKey];
	
	if (sccVolume == nil)  sccVolume = @"0";
	[defaults setObject:sccVolume forKey:sccVolumeKey];
	
	if (oplVolume == nil)  oplVolume = @"0";
	[defaults setObject:oplVolume forKey:oplVolumeKey];
	
	if (opllVolume == nil)  opllVolume = @"0";
	[defaults setObject:opllVolume forKey:opllVolumeKey];
    
    if (defaultPlayTime == nil)  defaultPlayTime = @"90";
    [defaults setObject:defaultPlayTime forKey:playTimeKey];
    
	
	//remoteControl = [[AppleRemote alloc] initWithDelegate: self];

	//[remoteControl startListening: self];
	
	myKSS = [[kssObject alloc] init];
	
	[myKSS createAudio]; // Create Audio Stuff.

	[myKSS setSongNumber:[NSNumber numberWithInt:0]];
	[myKSS setVdpSpeed:[NSNumber numberWithInt:[prefVdpSpeed intValue]]];

    [myKSS setFrameRate:[NSNumber numberWithInt:44100]];
    [myKSS setBufferSize:[NSNumber numberWithInt:735]];

    [myKSS setCpuSpeed:[NSNumber numberWithInt:[prefCpuSpeed intValue]]];
    [myKSS setDefaultPlayTime:[NSNumber numberWithInt:[defaultPlayTime intValue]]];
    
	[myKSS changeMasterVolume:[NSNumber numberWithInt:[prefMasterVolume intValue]]];
	[myKSS changePsgVolume:[NSNumber numberWithInt:[psgVolume intValue]]];
	[myKSS changeSccVolume:[NSNumber numberWithInt:[sccVolume intValue]]];	
	[myKSS changeOplVolume:[NSNumber numberWithInt:[oplVolume intValue]]];
	[myKSS changeOpllVolume:[NSNumber numberWithInt:[opllVolume intValue]]];
	
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
    dispatch_async(dispatch_get_main_queue(),^ {
    if (_playerController == nil)
    {
        _playerController = [[kssPlayer alloc] initWithWindowNibName:@"kssPlayer"];
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
    // NSLog(@"{openFile}  Hello Ric!");
     return TRUE;
}
	
@end

