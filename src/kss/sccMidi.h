//
//  sccMidi.h
//  kss
//
//  Created by Alex Rouge on 17/08/15.
//
//

#import <Cocoa/Cocoa.h>
#import "kssObject.h"
#import "AUDIOToolbox.h"
#import <CoreMIDI/MIDIServices.h>

@interface sccMidi : NSWindowController
{
    
    IBOutlet id sccVolumesMatrix;
    IBOutlet id sccChannelsMatrix;
    IBOutlet id sccProgramMatrix;
    IBOutlet id sccLowThersholdMatrix;
    IBOutlet id sccHighThersholdMatrix;
    IBOutlet id sccLevelIndicatorMatrix;
    IBOutlet id sccEnabledMatrix;
    IBOutlet id sccLowTextMatrix;
    IBOutlet id sccHighTextMatrix;
    
    IBOutlet id sccMidiPortsMatrix;
    
    kssObject *sccMidiKss;
    AUDIOToolbox *myAudioToolBox;
    
    MIDIDeviceRef myMidiDeviceRef;
    MIDIClientRef myMidiClientRef;
    
    MIDIEndpointRef midiEndPointRef[5];
    MIDIEndpointRef lastMidiEndPointRef[5];

    MIDIPortRef myMidiOutputPort;
    MIDITimeStamp timeStamp;
    
    NSNotificationCenter *nc;

    int sccNotes[5];
    int lastSccNotes[5];
    int sccVolumes[5];
    int lastSccVolumes[5];
    bool sccNoteOnOff[5];
    bool lastSccNoteOnOff[5];
    int midiProgram[5];
    int lastMidiProgram[5];
    
    int sccChannelEnabled[5];
    int lastSccChannelEnabled[5];
    
    int sccMidiPorts[5];
    int lastSccMidiPorts[5];
    
    int sccMidiChannels[5];
    int lastSccMidiChannels[5];
    
    int sccLowThersholds[5];
    int sccHighThersholds[5];
}

-(IBAction)setMidiPort:(id)sender;
-(void)scanMidiPorts;
-(IBAction)rescanMidiPorts:(id)sender;
-(IBAction)resetThersholdValues:(id)sender;
-(IBAction)panic:(id)sender;
-(OSStatus)sendMidiPacket:(Byte *)packet sccChannel:(int)channel size:(int)size;

@end
