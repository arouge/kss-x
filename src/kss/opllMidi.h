//
//  opllMidi.h
//  kss
//
//  Created by Alex Rouge on 22/09/15.
//
//

#import <Cocoa/Cocoa.h>
#import "libKss.h"
#import "AUDIOToolbox.h"
#import <CoreMIDI/MIDIServices.h>

@interface opllMidi : NSWindowController
{
    
    IBOutlet id opllVolumesMatrix;
    IBOutlet id opllChannelsMatrix;
    IBOutlet id opllProgramMatrix;
    IBOutlet id opllLowThersholdMatrix;
    IBOutlet id opllHighThersholdMatrix;
    IBOutlet id opllLevelIndicatorMatrix;
    IBOutlet id opllEnabledMatrix;
    IBOutlet id opllLowTextMatrix;
    IBOutlet id opllHighTextMatrix;
    IBOutlet id opllInstrumentsMatrix;
    
    int mt32SoundMap[16];
    int gmSoundTable[16];
    
    IBOutlet id opllMidiPortsMatrix;
    
    kssObject *opllMidiKss;
    AUDIOToolbox *myAudioToolBox;
    
    MIDIDeviceRef myMidiDeviceRef;
    MIDIClientRef myMidiClientRef;
    
    MIDIEndpointRef midiEndPointRef[9];
    MIDIEndpointRef lastMidiEndPointRef[9];
    
    MIDIPortRef myMidiOutputPort;
    MIDITimeStamp timeStamp;
    
    NSNotificationCenter *nc;
    
    int opllNotes[9];
    int lastOpllNotes[9];
    int opllVolumes[9];
    int lastOpllVolumes[9];
    bool opllNoteOnOff[9];
    bool lastOpllNoteOnOff[9];
    int midiProgram[9];
    int lastMidiProgram[9];
    int opllInstruments[9];
    int lastOpllInstruments[9];

    int opllChannelEnabled[9];
    int lastOpllChannelEnabled[9];
    
    int opllMidiPorts[9];
    int lastOpllMidiPorts[9];
    
    int opllMidiChannels[9];
    int lastOpllMidiChannels[9];
    
    int opllLowThersholds[9];
    int opllHighThersholds[9];
    IBOutlet id opllRegMatrix;

    
}

-(IBAction)setMidiPort:(id)sender;
-(void)scanMidiPorts;
- (IBAction)rescanMidiPorts:(id)sender;
-(IBAction)resetThersholdValues:(id)sender;
-(IBAction)panic:(id)sender;
- (OSStatus)sendMidiPacket:(Byte *)packet opllChannel:(int)channel size:(int)size;

@end
