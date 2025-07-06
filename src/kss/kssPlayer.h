/* kssPlayer */

#import <Cocoa/Cocoa.h>
#import "mainMenu.h"
#import "libKss.h"
//#import "m3uObject.h"
#import "m3uParser.h"
#import "AUDIOToolbox.h"

@interface kssPlayer : NSWindowController
{
	NSDate *ourStartTime;
    AUDIOToolbox *myAudioToolBox;

	IBOutlet id nextButton;
	IBOutlet id respectTime;
	IBOutlet id randomOutlet;
	IBOutlet id totalTimeOutlet;
	IBOutlet id trackNameOutlet;
	IBOutlet id showMixerOutlet;
    IBOutlet id directAccessOutlet;
    IBOutlet id masterVolumeOutlet;
    IBOutlet id playTime;
    
    IBOutlet id songTitle;
	IBOutlet id playButton;
	IBOutlet id playListeToggle;
	IBOutlet id playListTableView;
	IBOutlet id fastForwardOutlet;
    
	IBOutlet id kssImage;
	IBOutlet id imageWindow;
	
	bool timeToShow;
	int selectedPlayListItem;
	int timeToChange;
	kssObject *playerKSS;
    
	NSMutableArray *m3uArray;
	NSTimer *myTimer;
	
	m3uParser *myParser;
	
	NSEvent *theEvent;
}

-(void)openFile;
-(NSMutableArray *)openKss;
-(void)updateImage;
-(int)aleatoire:(int)min maximum:(int)max;
-(IBAction)timeToDisplay:(id)sender;
-(IBAction)openM3u:(id)sender;

-(void)onDoubleClick;


- (void) updateProgressBar;
-(void)updateSongTitle;

- (IBAction)masterVolume:(id)sender;
- (IBAction)next:(NSButton *)sender;
- (IBAction)playListToggle:(id)sender;
- (IBAction)previous:(id)sender;
- (IBAction)togglePause:(id)sender;
- (IBAction)volumeHigh:(id)sender;
- (IBAction)volumeLow:(id)sender;

@end
