/* exportwave */

#import <Cocoa/Cocoa.h>
#import "AUDIOToolbox.h"
#import "kssplay.h"
#import "libKss.h"
#import "m3uParser.h"


@interface exportwave : NSWindowController
{
    IBOutlet id cancelButtonOutlet;
    IBOutlet id destinationTextFieldOutlet;
    IBOutlet id exportButtonOutlet;
    IBOutlet id playlistTextFieldOutlet;
    IBOutlet id progressbarOutlet;
	IBOutlet id inheritDevicesOutlet;
	//IBOutlet id exportWindow;
	
	NSString *kssFileName;
	
	NSMutableArray *m3uArray;
	//m3uObject *myM3uObject;
	//m3uObject *tempObject;
	NSString *targetFolderName;
	bool _isPlaying;
	kssObject *exportKss;
	
	// KSS Libraries
	KSSPLAY *kssplay;
	KSS	*kss;
	int sourceFileChoosen;
	int destFolderChoosen;
	int opllPan[14];
	int psgVolume, sccVolume, oplVolume, opllVolume, masterVolume;
	int psgMask, sccMask, oplMask, opllMask;
    int totalPlayTime, calculationTime;
    int frequency;

}
- (IBAction)cancelExport:(id)sender;
- (IBAction)exportAsWave:(id)sender;
- (IBAction)selectDestinationFolder:(id)sender;
- (IBAction)selectM3u:(id)sender;
@end
