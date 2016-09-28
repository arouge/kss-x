//
//  psgMidi.h
//  kss
//
//  Created by Alex Rouge on 22/09/15.
//
//

#import <Cocoa/Cocoa.h>
#import "kssObject.h"
#import "AUDIOToolbox.h"
#import <CoreMIDI/MIDIServices.h>

@interface psgMidi : NSWindowController
{
    
    IBOutlet id psgVolumesMatrix;
    IBOutlet id psgChannelsMatrix;
    IBOutlet id psgProgramMatrix;
    IBOutlet id psgLowThersholdMatrix;
    IBOutlet id psgHighThersholdMatrix;
    IBOutlet id psgLevelIndicatorMatrix;
    IBOutlet id psgEnabledMatrix;
    IBOutlet id psgLowTextMatrix;
    IBOutlet id psgHighTextMatrix;
    
    IBOutlet id psgMidiPortsMatrix;
    
    kssObject *psgMidiKss;
    AUDIOToolbox *myAudioToolBox;
    
    MIDIDeviceRef myMidiDeviceRef;
    MIDIClientRef myMidiClientRef;
    
    MIDIEndpointRef midiEndPointRef[3];
    MIDIEndpointRef lastMidiEndPointRef[3];
    
    MIDIPortRef myMidiOutputPort;
    MIDITimeStamp timeStamp;
    
    NSNotificationCenter *nc;

    int psgNotes[3];
    int lastPsgNotes[3];
    int psgVolumes[3];
    int lastPsgVolumes[3];
    bool psgNoteOnOff[3];
    bool lastPsgNoteOnOff[3];
    int midiProgram[3];
    int lastMidiProgram[3];
    
    int psgChannelEnabled[3];
    int lastPsgChannelEnabled[3];
    
    int psgMidiPorts[3];
    int lastPsgMidiPorts[3];
    
    int psgMidiChannels[3];
    int lastPsgMidiChannels[3];
    
    int psgLowThersholds[3];
    int psgHighThersholds[3];
    IBOutlet id psgRegisters;

}

-(IBAction)setMidiPort:(id)sender;
-(void)scanMidiPorts;
- (IBAction)rescanMidiPorts:(id)sender;
-(IBAction)resetThersholdValues:(id)sender;
-(IBAction)panic:(id)sender;
- (OSStatus)sendMidiPacket:(Byte *)packet psgChannel:(int)channel size:(int)size;

@end
