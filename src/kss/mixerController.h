/* mixerController */

#import <Cocoa/Cocoa.h>
#import "libKss.h"

@interface mixerController : NSWindowController
{
	kssObject *mixerKss;
	int tempPsgVolume;
	int tempOpllVolume;
	int tempOplVolume;
	int tempSccVolume;
	
    IBOutlet id masterVolume;
    IBOutlet id opllMute;
    IBOutlet id opllVolume;
    IBOutlet id oplMute;
    IBOutlet id oplVolume;
    IBOutlet id psgMute;
    IBOutlet id psgVolume;
    IBOutlet id sccMute;
    IBOutlet id sccVolume;
	IBOutlet id masterVolumeValue;
	IBOutlet id psgVolumeValue;
	IBOutlet id sccVolumeValue;
	IBOutlet id oplVolumeValue;
	IBOutlet id opllVolumeValue;
	
}
- (IBAction)changeMasterVolume:(id)sender;
- (IBAction)changeOpllVolume:(id)sender;
- (IBAction)changeOplVolume:(id)sender;
- (IBAction)changePsgVolume:(id)sender;
- (IBAction)changeSccVolume:(id)sender;
- (IBAction)muteOpl:(id)sender;
- (IBAction)muteOpll:(id)sender;
- (IBAction)mutePsg:(id)sender;
- (IBAction)muteScc:(id)sender;
- (IBAction)panPsg:(id)sender;
- (IBAction)panScc:(id)sender;
- (IBAction)panOpl:(id)sender;
- (IBAction)panOpll:(id)sender;
- (IBAction)resetVolumes:(id)sender;

@end
