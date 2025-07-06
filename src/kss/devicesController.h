/* devicesController */

#import <Cocoa/Cocoa.h>
#import "libKss.h"

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
	NSInteger psgMask;
    NSInteger sccMask;
    NSInteger oplMask;
    NSInteger opllMask;
}
- (IBAction)devicesOplInvert:(id)sender;
- (IBAction)devicesOpllInvert:(id)sender;
- (IBAction)devicesOpllPan:(id)sender;
- (IBAction)devicesChange:(id)sender;
- (IBAction)devicesPsgInvert:(id)sender;
- (IBAction)devicesSccInvert:(id)sender;
@end
