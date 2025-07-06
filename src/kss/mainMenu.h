/* miniPlayer */

#import <Cocoa/Cocoa.h>
#import "libKss.h"
#import "KSSDocument.h"

@class preferencesController; // Forward declaration of our controller subclass
@class devicesController; // Forward declaration of our controller subclass
@class aboutWindow; // Forward declaration of our controller subclass
@class mixerController; // Forward declaration of our controller subclass
@class exportwave;
@class kssPlayer;
@class psgMidi;
@class sccMidi;
@class opllMidi;

@interface mainMenu : NSObject
{
#define vdpKey @"vdpSpeed"
#define frameRateKey @"frameRate"
#define bufferKey @"bufferSize"
#define mgsdrvKey @"loadMgs"
#define kinrou5Key @"loadKinrou5"
#define mpkKey	@"loadMpk"
#define mpk103Key	@"loadMpk103"
#define opxKey @"loadOpx"
#define cpuKey @"cpuSpeed"
#define masterVolumeKey @"masterVolume"
#define psgVolumeKey  @"psgVolume"
#define sccVolumeKey  @"sccVolume"
#define oplVolumeKey  @"oplVolume"
#define opllVolumeKey @"opllVolume"
#define playTimeKey @"playTime"



	preferencesController		*_prefController; 	// This will point to our window controller subclass
	exportwave					*_exportwave;
	devicesController			*_devController;
	aboutWindow					*_aboutController;
	mixerController				*_mixController;
	kssPlayer					*_playerController;
	psgMidi                     *_psgMidi;
    sccMidi                     *_sccMidi;
    opllMidi                    *_opllMidi;
    	
	kssObject *myKSS;

}

- (IBAction)volumeHigh:(id)sender;
- (IBAction)volumeLow:(id)sender;
- (IBAction)replaySong:(id)sender;
- (IBAction)displayPlayer:(id)sender;
- (IBAction)displayMixer:(id)sender;
- (IBAction)displayAboutBox:(id)sender;
- (IBAction)displayPreferencesWindow:(id)sender;
- (IBAction)displayExport:(id)sender;
- (IBAction)displayPsgMidi:(id)sender;

- (IBAction)miniPlayerOpenKSS:(id)sender;
- (IBAction)miniPlayerNext:(id)sender;
- (IBAction)miniPlayerNextTen:(id)sender;
- (IBAction)miniPlayerPreviousTen:(id)sender;
- (IBAction)miniPlayerPrevious:(id)sender;

- (BOOL)application:NSApplication openFile:(NSString *)filename;


@end
