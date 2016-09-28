/* devicesController */

#import <Cocoa/Cocoa.h>
#import "kssObject.h"

@interface devicesController : NSWindowController
{
	IBOutlet id devicesChange;
    IBOutlet id devicesOpl;
    IBOutlet id devicesOplInvert;
    IBOutlet id devicesOpll;
    IBOutlet id devicesOpllInvert;
    IBOutlet id devicesOpllPan;
    IBOutlet id devicesPsg;
    IBOutlet id devicesPsgInvert;
    IBOutlet id devicesScc;
    IBOutlet id devicesSccInvert;
	
	kssObject *devicesKss;
	int psgMask;
	int sccMask;
	int oplMask;
	int opllMask;
}
- (IBAction)devicesOplInvert:(id)sender;
- (IBAction)devicesOpllInvert:(id)sender;
- (IBAction)devicesOpllPan:(id)sender;
- (IBAction)devicesChange:(id)sender;
- (IBAction)devicesPsgInvert:(id)sender;
- (IBAction)devicesSccInvert:(id)sender;
@end
