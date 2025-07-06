//
//  psgMidi.m
//  kss
//
//  Created by Alex Rouge on 22/09/15.
//
//

#import "psgMidi.h"

@interface psgMidi ()

@end

@implementation psgMidi

- (void)windowDidLoad {
    [super windowDidLoad];
    
    psgMidiKss = [[kssObject alloc] init];
    myAudioToolBox = [[AUDIOToolbox alloc] init];
    
    [self scanMidiPorts];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i < 3; i++)
        {
            for(int j=0; j < 16; j++)
                [[psgChannelsMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j+1] stringValue]];
            [[psgChannelsMatrix cellAtRow:0 column:i] selectItemAtIndex:i];
            for(int j=0; j < 128; j++)
                [[psgProgramMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j+1] stringValue]];;
            for(int j=0; j < 32; j++)
                [[psgLowThersholdMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j] stringValue]];;
            for(int j=0; j < 32; j++)
                [[psgHighThersholdMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j] stringValue]];
            [[psgHighThersholdMatrix cellAtRow:0 column:i] selectItemAtIndex:31];
            
        }
    });
    
    // Initialisation des variables courantes
    for (int i =0 ; i < 3; i++)
    {
        lastMidiProgram[i] =0;
        midiProgram[i] =0;
    }
    
    nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(processNotes)
               name:@"newNotes"
             object:nil];
}

- (IBAction)rescanMidiPorts:(id)sender
{
    [self scanMidiPorts];
}

- (IBAction)resetThersholdValues:(id)sender
{
    for(int i = 0 ; i<3; i++)
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            [[psgLowTextMatrix cellAtRow:0 column:i] setIntValue:31];
            [[psgHighTextMatrix cellAtRow:0 column:i] setIntValue:0];
        });
    }
}

- (void)processNotes
{
    OSStatus status;
    PSG *psg = [psgMidiKss psg];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int j=0; j < 8; j++)
        {
            [[psgRegisters cellAtRow:0 column:j] setStringValue:[NSString stringWithFormat:@"0x%02x", psg->reg[j]]];
        }
        for(int j=0; j < 8; j++)
        {
            [[psgRegisters cellAtRow:1 column:j] setStringValue:[NSString stringWithFormat:@"0x%02x", psg->reg[j+8]]];
        }
    });

    for(int i=0; i<3;i++)
    {
        lastPsgVolumes[i] = psgVolumes[i];
        lastPsgNotes[i] = psgNotes[i];
        lastPsgNoteOnOff[i] = psgNoteOnOff[i];
        psgVolumes[i] = psg->volume[i] & 31;
        dispatch_async(dispatch_get_main_queue(),^ {
            psgMidiChannels[i] = [[psgChannelsMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        });
        
        psgNotes[i] = [[myAudioToolBox convertFrequency:[NSNumber numberWithInt:psg->freq[i]] deviceName:EDSC_PSG] intValue];
        midiProgram[i] = [[psgProgramMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        psgMidiPorts[i] = [[psgMidiPortsMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [[psgVolumesMatrix cellAtRow:0 column:i] setIntValue:psgVolumes[i]];
            [[psgLevelIndicatorMatrix cellAtRow:0 column:i] setIntValue:psgVolumes[i]];
        });
        
        if(psgVolumes[i] > [[psgHighTextMatrix cellAtRow:0 column:i] intValue])
            dispatch_async(dispatch_get_main_queue(),^ {
                [[psgHighTextMatrix cellAtRow:0 column:i] setIntValue:psgVolumes[i]];
            });
        if(psgVolumes[i] < [[psgLowTextMatrix cellAtRow:0 column:i] intValue])
            dispatch_async(dispatch_get_main_queue(),^ {
                [[psgLowTextMatrix cellAtRow:0 column:i] setIntValue:psgVolumes[i]];
            });
        
        if(psgMidiChannels[i] != lastPsgMidiChannels[i])
        {
            Byte noteOff[] = { 0x80+lastPsgMidiChannels[i], lastPsgNotes[i] ,0x40};
            status = [self sendMidiPacket:noteOff psgChannel:i size:sizeof(noteOff)];
            
            lastPsgNoteOnOff[i] = psgNoteOnOff[i];
            lastPsgNotes[i] = psgNotes[i];
        }
        lastPsgMidiChannels[i] = psgMidiChannels[i];
        
        if(psgMidiPorts[i] != lastPsgMidiPorts[i])
        {
            Byte noteOff[] = { 0x80+psgMidiChannels[i], lastPsgNotes[i] ,0x40};
            status = [self sendMidiPacket:noteOff psgChannel:i size:sizeof(noteOff)];
            
            lastPsgNoteOnOff[i] = psgNoteOnOff[i];
            lastPsgNotes[i] = psgNotes[i];
        }
        lastPsgMidiPorts[i] = psgMidiPorts[i];
        dispatch_async(dispatch_get_main_queue(),^ {
            psgChannelEnabled[i] = [[psgEnabledMatrix cellAtRow:0 column:i] intValue];
        });
        
        if(!psgChannelEnabled[i])
        {
            if(!lastPsgNoteOnOff[i])
            {
                Byte noteOnOff[] = { 0x80+psgMidiChannels[i], lastPsgNotes[i] ,0x40};
                status = [self sendMidiPacket:noteOnOff psgChannel:i size:3];
                                
                lastPsgNotes[i] = psgNotes[i];
            }
            continue;
        }
        
        psgLowThersholds[i] = [[psgLowThersholdMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        psgHighThersholds[i] = [[psgHighThersholdMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        
        /*
        if(!psgChannelEnabled[i] && !lastPsgChannelEnabled[i])
        {
            Byte noteOff[] = {0x80+psgMidiChannels[i], lastPsgNotes[i],0x40};
            status = [self sendMidiPacket:noteOff psgChannel:i size:sizeof(noteOff)];
            
            lastPsgNoteOnOff[i] = 0;
            lastPsgVolumes[i] = 0;
        }
        */
        
        if(midiProgram[i] != lastMidiProgram[i])
        {
            Byte program[] = {0xC0+psgMidiChannels[i], midiProgram[i]};
            
            status = [self sendMidiPacket:program psgChannel:i size:sizeof(program)];
            
            lastMidiProgram[i] = midiProgram[i];
            
        }
        
        if(psgChannelEnabled[i])
        {

            if(psgVolumes[i] <= psgLowThersholds[i] && lastPsgVolumes[i] > psgLowThersholds[i])
            {
                Byte noteOff[] = { 0x80+psgMidiChannels[i], lastPsgNotes[i] ,0x40};
                status = [self sendMidiPacket:noteOff psgChannel:i size:sizeof(noteOff)];
                
                lastPsgNoteOnOff[i] = 0;
                lastPsgVolumes[i] = 0;
                continue;
            }
            
            if(psgNotes[i] != lastPsgNotes[i] || psgVolumes[i] >= psgHighThersholds[i])
            {
                Byte noteOff[] = { 0x80+psgMidiChannels[i], lastPsgNotes[i] ,0x40};
                
                status = [self sendMidiPacket:noteOff psgChannel:i size:3];
                
                Byte noteOn[] = { 0x90+psgMidiChannels[i] ,psgNotes[i] , (psgVolumes[i]*4)&127};
                status = [self sendMidiPacket:noteOn psgChannel:i size:sizeof(noteOn)];
                
                lastPsgNoteOnOff[i] = psgNotes[i];
                lastPsgVolumes[i] = psgVolumes[i];
                continue;
            }
        }
    }
}

- (OSStatus)sendMidiPacket:(Byte *)packet psgChannel:(int)channel size:(int)size
{
    OSStatus status;
    Byte buffer[256];
    
    MIDIPacketList *myPacketList = (MIDIPacketList*)buffer;
    MIDIPacket *myPacket = MIDIPacketListInit(myPacketList);
    
    myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, size, packet);
    
    if ((status = MIDISend(myMidiOutputPort, midiEndPointRef[channel], myPacketList)))
    {
        return status;
    }
    
    return status;
}

- (void)scanMidiPorts
{
    OSStatus status;
    
   // myMidiClientRef = NULL;
    
    if((status = MIDIClientCreate(CFSTR("Testing"), NULL, NULL, &myMidiClientRef)))
    {
        printf("Error\n");
        exit(status);
    }
    
    if((status = MIDIOutputPortCreate(myMidiClientRef, CFSTR("Output"), &myMidiOutputPort)))
    {
        printf("Error2\n");
        exit(status);
    }
    
    timeStamp = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i =0 ; i<3; i++)
        {
            [[psgMidiPortsMatrix cellAtRow:0 column:i] removeAllItems];
        }
    });
    
    
    NSInteger numberOfDestination = MIDIGetNumberOfDestinations();
    if(numberOfDestination)
    {
        for(int i=0;i<numberOfDestination;i++)
        {
            myMidiDeviceRef = MIDIGetDestination(i);
            
            CFStringRef midiDeviceName;
            
            MIDIObjectGetStringProperty(myMidiDeviceRef, kMIDIPropertyName, &midiDeviceName);
            NSString *testDestination = (__bridge NSString *)midiDeviceName;
            
            dispatch_async(dispatch_get_main_queue(),^ {
                for(int j = 0 ; j < 3; j++)
                    [[psgMidiPortsMatrix cellAtRow:0 column:j] addItemWithTitle:testDestination];
            });
        }
    }
    
    for(int i=0;i<3;i++)
    {
        if(MIDIGetNumberOfDestinations())
        {
            lastMidiEndPointRef[i] = midiEndPointRef[i];
            midiEndPointRef[i] = MIDIGetDestination(0);
            [[psgMidiPortsMatrix cellAtRow:0 column:i] selectItemAtIndex:0];
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
  //  NSLog(@"blablabla");
}

-(IBAction)setMidiPort:(id)sender
{
    NSInteger selectedColumn;
    NSInteger selectedRow;
    
    selectedRow = [sender selectedRow];
    selectedColumn = [sender selectedColumn];
    lastMidiEndPointRef[selectedColumn] = midiEndPointRef[selectedColumn];
    midiEndPointRef[selectedColumn] = MIDIGetDestination([[psgMidiPortsMatrix cellAtRow:selectedRow column:selectedColumn] indexOfSelectedItem]);
}



-(IBAction)panic:(id)sender
{
    for(int i=0; i<3;i++)
    {
        OSStatus status;
        Byte buffer[256];
        
        MIDIPacketList *myPacketList = (MIDIPacketList*)buffer;
        MIDIPacket *myPacket = MIDIPacketListInit(myPacketList);
        
        Byte lastNoteOff[3] = { 0x80+psgMidiChannels[i], lastPsgNotes[i] ,0x40};
        myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, 3, lastNoteOff);
        Byte noteOff[3] = { 0x80+psgMidiChannels[i], psgNotes[i] ,0x40};
        myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, 3, noteOff);
        
        if ((status = MIDISend(myMidiOutputPort, midiEndPointRef[i], myPacketList)))
        {
            printf("Problem\n");
            exit(status);
        }
    }
}

@end
