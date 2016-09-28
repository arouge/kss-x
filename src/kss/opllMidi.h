//
//  opllMidi.h
//  kss
//
//  Created by Alex Rouge on 21/08/15.
//
//

#import <Cocoa/Cocoa.h>
#import "kssObject.h"
#import "AUDIOToolbox.h"
#import <CoreMIDI/MIDIServices.h>

@interface opllMidi : NSWindowController
{
    kssObject *opllMidiKss;
    AUDIOToolbox *myAudioToolBox;
    
    MIDIDeviceRef myMidiDeviceRef;
    MIDIClientRef myMidiClientRef;
    
    MIDIEndpointRef midiEndPointRef[9];
    MIDIEndpointRef lastMidiEndPointRef[9];
    
    MIDIPortRef myMidiOutputPort;
    MIDITimeStamp timeStamp;

    IBOutlet id opllMidiPortsMatrix;
    IBOutlet id opllChannelsMatrix;
    IBOutlet id opllInstrumentsMatrix;

    IBOutlet id opllEnabledMatrix;
    int mt32SoundMap[16];
    int gmSoundTable[16];
    
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
    
    BOOL opllChannelEnabled[9];
    BOOL lastOpllChannelEnabled[9];
    
    int opllMidiPorts[9];
    int lastOpllMidiPorts[9];
    
    int opllMidiChannels[9];
    int lastOpllMidiChannels[9];
    
    int opllLowThersholds[9];
    int opllHighThersholds[9];
    
    IBOutlet id opllRegMatrix;
}
-(IBAction)setMidiPort:(id)sender;
-(IBAction)enableChannel:(id)sender;
@end
