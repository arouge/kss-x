//
//  sccMidi.m
//  kss
//
//  Created by Alex Rouge on 17/08/15.
//
//

#import "sccMidi.h"

@interface sccMidi ()

@end

@implementation sccMidi

- (void)windowDidLoad {
    [super windowDidLoad];
    
    sccMidiKss = [[kssObject alloc] init];
    myAudioToolBox = [[AUDIOToolbox alloc] init];
   
    [self scanMidiPorts];

    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i < 5; i++)
        {
            for(int j=0; j < 16; j++)
                [[sccChannelsMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j+1] stringValue]];
            [[sccChannelsMatrix cellAtRow:0 column:i] selectItemAtIndex:i];
            for(int j=0; j < 128; j++)
                [[sccProgramMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j+1] stringValue]];;
            for(int j=0; j < 16; j++)
                [[sccLowThersholdMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j] stringValue]];;
            for(int j=0; j < 16; j++)
                [[sccHighThersholdMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j] stringValue]];
            [[sccHighThersholdMatrix cellAtRow:0 column:i] selectItemAtIndex:15];
            
        }
    });
   
    // Initialisation des variables courantes
    for (int i =0 ; i < 5; i++)
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
    for(int i = 0 ; i<5; i++)
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            [[sccLowTextMatrix cellAtRow:0 column:i] setIntValue:31];
            [[sccHighTextMatrix cellAtRow:0 column:i] setIntValue:0];
        });
    }
}

- (void)processNotes
{
    OSStatus status;
    SCC *scc = [sccMidiKss scc];
    
    for(int i=0; i<5;i++)
    {
        lastSccVolumes[i] = sccVolumes[i];
        lastSccNotes[i] = sccNotes[i];
        lastSccNoteOnOff[i] = sccNoteOnOff[i];
        sccVolumes[i] = scc->volume[i] & 15;
        sccMidiChannels[i] = [[sccChannelsMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        sccNotes[i] = [[myAudioToolBox convertFrequency:[NSNumber numberWithInt:scc->freq[i]] deviceName:EDSC_SCC] intValue];
        midiProgram[i] = [[sccProgramMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        sccMidiPorts[i] = [[sccMidiPortsMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [[sccVolumesMatrix cellAtRow:0 column:i] setIntValue:sccVolumes[i]];
            [[sccLevelIndicatorMatrix cellAtRow:0 column:i] setIntValue:sccVolumes[i]];
        });

        if(sccVolumes[i] > [[sccHighTextMatrix cellAtRow:0 column:i] intValue])
             dispatch_async(dispatch_get_main_queue(),^ {
            [[sccHighTextMatrix cellAtRow:0 column:i] setIntValue:sccVolumes[i]];
        });
        if(sccVolumes[i] < [[sccLowTextMatrix cellAtRow:0 column:i] intValue])
            dispatch_async(dispatch_get_main_queue(),^ {
                [[sccLowTextMatrix cellAtRow:0 column:i] setIntValue:sccVolumes[i]];
            });
        
        if(sccMidiChannels[i] != lastSccMidiChannels[i])
        {
            Byte noteOff[] = { 0x80+lastSccMidiChannels[i], lastSccNotes[i] ,0x40};
            status = [self sendMidiPacket:noteOff sccChannel:i size:sizeof(noteOff)];
    
            lastSccNoteOnOff[i] = sccNoteOnOff[i];
            lastSccNotes[i] = sccNotes[i];
        }
        lastSccMidiChannels[i] = sccMidiChannels[i];

        if(sccMidiPorts[i] != lastSccMidiPorts[i])
        {
            Byte noteOff[] = { 0x80+sccMidiChannels[i], lastSccNotes[i] ,0x40};
            status = [self sendMidiPacket:noteOff sccChannel:i size:sizeof(noteOff)];
            
            lastSccNoteOnOff[i] = sccNoteOnOff[i];
            lastSccNotes[i] = sccNotes[i];
        }
        lastSccMidiPorts[i] = sccMidiPorts[i];
        
        sccChannelEnabled[i] = [[sccEnabledMatrix cellAtRow:0 column:i] intValue];
        sccLowThersholds[i] = [[sccLowThersholdMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        sccHighThersholds[i] = [[sccHighThersholdMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        
        if(!sccChannelEnabled[i] && !lastSccChannelEnabled[i])
        {
            Byte noteOff[] = {0x80+sccMidiChannels[i], lastSccNotes[i],0x40};
            status = [self sendMidiPacket:noteOff sccChannel:i size:sizeof(noteOff)];
            
            lastSccNoteOnOff[i] = 0;
            lastSccVolumes[i] = 0;
        }
        
        if(midiProgram[i] != lastMidiProgram[i])
        {
            Byte program[] = {0xC0+sccMidiChannels[i], midiProgram[i]};
            
            status = [self sendMidiPacket:program sccChannel:i size:sizeof(program)];
            
            lastMidiProgram[i] = midiProgram[i];

        }

        if(sccChannelEnabled[i])
        {
            if(sccVolumes[i] <= sccLowThersholds[i] && lastSccVolumes[i] > sccLowThersholds[i])
            {
                Byte noteOff[] = { 0x80+sccMidiChannels[i], lastSccNotes[i] ,0x40};
                status = [self sendMidiPacket:noteOff sccChannel:i size:sizeof(noteOff)];

                lastSccNoteOnOff[i] = 0;
                lastSccVolumes[i] = 0;
                continue;
            }
            
            if(sccNotes[i] != lastSccNotes[i] || sccVolumes[i] >= sccHighThersholds[i])
            {
                Byte noteOff[] = { 0x80+sccMidiChannels[i], lastSccNotes[i] ,0x40};
                
                status = [self sendMidiPacket:noteOff sccChannel:i size:3];
                
                Byte noteOn[] = { 0x90+sccMidiChannels[i] ,sccNotes[i] , sccVolumes[i]*8};
                status = [self sendMidiPacket:noteOn sccChannel:i size:sizeof(noteOn)];

                lastSccNoteOnOff[i] = sccNotes[i];
                lastSccVolumes[i] = sccVolumes[i];
                continue;
            }
        }
    }
}

- (OSStatus)sendMidiPacket:(Byte *)packet sccChannel:(int)channel size:(int)size
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

    myMidiClientRef = NULL;
    
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
            for(int i =0 ; i<5; i++)
            {
                [[sccMidiPortsMatrix cellAtRow:0 column:i] removeAllItems];
            }
    });

    
    int numberOfDestination = MIDIGetNumberOfDestinations();
    if(numberOfDestination)
    {
        for(int i=0;i<numberOfDestination;i++)
        {
            myMidiDeviceRef = MIDIGetDestination(i);
        
            CFStringRef midiDeviceName;
        
            MIDIObjectGetStringProperty(myMidiDeviceRef, kMIDIPropertyName, &midiDeviceName);
            NSString *testDestination = (__bridge NSString *)midiDeviceName;
        
            dispatch_async(dispatch_get_main_queue(),^ {
                for(int j = 0 ; j < 5; j++)
                    [[sccMidiPortsMatrix cellAtRow:0 column:j] addItemWithTitle:testDestination];
            });
        }
    }
    
    for(int i=0;i<5;i++)
    {
        if(MIDIGetNumberOfDestinations())
        {
            lastMidiEndPointRef[i] = midiEndPointRef[i];
            midiEndPointRef[i] = MIDIGetDestination(0);
            [[sccMidiPortsMatrix cellAtRow:0 column:i] selectItemAtIndex:0];
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"blablabla");
}

-(IBAction)setMidiPort:(id)sender
{
    int selectedColumn;
    int selectedRow;
    
    selectedRow = [sender selectedRow];
    selectedColumn = [sender selectedColumn];
    lastMidiEndPointRef[selectedColumn] = midiEndPointRef[selectedColumn];
    midiEndPointRef[selectedColumn] = MIDIGetDestination([[sccMidiPortsMatrix cellAtRow:selectedRow column:selectedColumn] indexOfSelectedItem]);
}



-(IBAction)panic:(id)sender
{
    for(int i=0; i<5;i++)
    {
        OSStatus status;
        Byte buffer[256];
    
        MIDIPacketList *myPacketList = (MIDIPacketList*)buffer;
        MIDIPacket *myPacket = MIDIPacketListInit(myPacketList);
    
        Byte lastNoteOff[3] = { 0x80+sccMidiChannels[i], lastSccNotes[i] ,0x40};
        myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, 3, lastNoteOff);
        Byte noteOff[3] = { 0x80+sccMidiChannels[i], sccNotes[i] ,0x40};
        myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, 3, noteOff);
    
        if ((status = MIDISend(myMidiOutputPort, midiEndPointRef[i], myPacketList)))
        {
            printf("Problem\n");
            exit(status);
        }
    }
}

@end
