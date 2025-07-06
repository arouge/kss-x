//
//  sccMidi.h
//  kss
//
//  Created by Alex Rouge on 17/08/15.
//
//

#import <Cocoa/Cocoa.h>
#import "libKss.h"
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
    NSInteger midiProgram[5];
    NSInteger lastMidiProgram[5];
    
    NSInteger sccChannelEnabled[5];
    NSInteger lastSccChannelEnabled[5];
    
    NSInteger sccMidiPorts[5];
    NSInteger lastSccMidiPorts[5];
    
    NSInteger sccMidiChannels[5];
    NSInteger lastSccMidiChannels[5];
    
    NSInteger sccLowThersholds[5];
    NSInteger sccHighThersholds[5];
}

-(IBAction)setMidiPort:(id)sender;
-(void)scanMidiPorts;
-(IBAction)rescanMidiPorts:(id)sender;
-(IBAction)resetThersholdValues:(id)sender;
-(IBAction)panic:(id)sender;
-(OSStatus)sendMidiPacket:(Byte *)packet sccChannel:(int)channel size:(int)size;

@end
