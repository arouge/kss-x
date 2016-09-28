/* preferencesController */

#import <Cocoa/Cocoa.h>
#import "kssObject.h"
#import "AUDIOToolbox.h"

@interface preferencesController : NSWindowController
{
	kssObject *anotherKSS;
    AUDIOToolbox *myAudioToolbox;
    
	IBOutlet id imageRef;
//    IBOutlet id bufferPopUp;
    IBOutlet id sampleRate;
    IBOutlet id preferencesVdpSpeed;
	IBOutlet id preferencesCpuSpeed;
	IBOutlet id defaultPlayTimeOutlet;	
}
- (IBAction)setVdpSpeed:(id)sender;
//- (IBAction)setBufferSize:(id)sender;
- (IBAction)apply:(id)sender;
- (IBAction)setCpuSpeed:(id)sender;
- (IBAction)setDefaultPlayTime:(id)sender;

@end
