//
//  opllMidi.m
//  kss
//
//  Created by Alex Rouge on 22/09/15.
//
//

#import "opllMidi.h"

@interface opllMidi ()

@end

@implementation opllMidi

- (void)windowDidLoad {
    [super windowDidLoad];
    
    opllMidiKss = [[kssObject alloc] init];
    myAudioToolBox = [[AUDIOToolbox alloc] init];
    gmSoundTable[0] = 11; // Original
    gmSoundTable[1] = 40; // Violin
    gmSoundTable[2] = 24; // Guitar
    gmSoundTable[3] = 01; // Piano
    gmSoundTable[4] = 73; // Flute
    gmSoundTable[5] = 71; // Clarinet
    gmSoundTable[6] = 68; // Oboe
    gmSoundTable[7] = 56; // Trumpet
    gmSoundTable[8] = 16; // Organ
    gmSoundTable[9] = 60; // Horn
    gmSoundTable[10] = 62; // Synthesizer
    gmSoundTable[11] = 46; // Harpischord
    gmSoundTable[12] = 11; // Vibraphone
    gmSoundTable[13] = 38; // Synth Bass
    gmSoundTable[14] = 32; // Acoustic Bass
    gmSoundTable[15] = 26; // Eletric Guitar
    
    mt32SoundMap[0] = 47; // Original
    mt32SoundMap[1] = 52; // Violin
    mt32SoundMap[2] = 59; // Guitar
    mt32SoundMap[3] = 04; // Piano
    mt32SoundMap[4] = 72; // Flute
    mt32SoundMap[5] = 82; // Clarinet
    mt32SoundMap[6] = 84; // Oboe
    mt32SoundMap[7] = 88; // Trumpet
    mt32SoundMap[8] = 9; // Organ
    mt32SoundMap[9] = 92; // Horn
    mt32SoundMap[10] = 44; // Synthesizer
    mt32SoundMap[11] = 16; // Harpischord
    mt32SoundMap[12] = 97; // Vibraphone
    mt32SoundMap[13] = 30; // Synth Bass
    mt32SoundMap[14] = 64; // Acoustic Bass
    mt32SoundMap[15] = 60; // Eletric Guitar
    [self scanMidiPorts];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i < 9; i++)
        {
            for(int j=0; j < 16; j++)
                [[opllChannelsMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j+1] stringValue]];
            [[opllChannelsMatrix cellAtRow:0 column:i] selectItemAtIndex:i];
            for(int j=0; j < 128; j++)
                [[opllProgramMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j+1] stringValue]];;
            for(int j=0; j < 32; j++)
                [[opllLowThersholdMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j] stringValue]];;
            for(int j=0; j < 32; j++)
                [[opllHighThersholdMatrix cellAtRow:0 column:i] addItemWithTitle:[[NSNumber numberWithInt:j] stringValue]];
            [[opllHighThersholdMatrix cellAtRow:0 column:i] selectItemAtIndex:31];
            
        }
    });
    
    // Initialisation des variables courantes
    for (int i =0 ; i < 9; i++)
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
    for(int i = 0 ; i<9; i++)
    {
        dispatch_async(dispatch_get_main_queue(),^ {
            [[opllLowTextMatrix cellAtRow:0 column:i] setIntValue:31];
            [[opllHighTextMatrix cellAtRow:0 column:i] setIntValue:0];
        });
    }
}

- (void)processNotes
{
    OSStatus status;
    OPLL *opll = [opllMidiKss opll];
    
    int numberChannel;
    
    if(opll->reg[0x0e] & 16)
        numberChannel = 6;
    if(!(opll->reg[0x0e] & 16))
        numberChannel = 9;
    
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int j=0; j<4;j++)
        {
            for(int i=0; i < 16; i++)
            {
                [[opllRegMatrix cellAtRow:j column:i] setStringValue:[NSString stringWithFormat:@"0x%02x",opll->reg[(j*16)+i]]];
            }
        }
        
    });
    
    for(int i=0; i<numberChannel; i++)
    {
        float basefreq = 3579545.454545/72.0;
        float factor = basefreq / (1<<18);
        
        int frequence = (((opll->reg[0x20+i] & 1) << 8) + opll->reg[0x10+i]) * factor * (1 << (((opll->reg[0x20+i]) & 15) >> 1));

        opllNotes[i] = [[myAudioToolBox convertFrequency:[NSNumber numberWithInt:(int)round(frequence)] deviceName:EDSC_OPLL] intValue];
        
        opllNoteOnOff[i] = opll->reg[0x20+i] & 16;
        opllVolumes[i] = 127 - ((opll->reg[0x30+i] &15)*8 + 1/2);
        
        opllInstruments[i] = (opll->reg[0x30+i] & 0xF0) >> 4;
        dispatch_async(dispatch_get_main_queue(),^ {
            opllChannelEnabled[i] = [[opllEnabledMatrix cellAtRow:0 column:i] intValue];
            opllMidiChannels[i] = [[opllChannelsMatrix cellAtRow:0 column:i] indexOfSelectedItem];
        });
        dispatch_async(dispatch_get_main_queue(),^ {

            //[[opllInstrumentsMatrix cellAtRow:0 column:0] addItemWithTitle:@"Original"];

        });
        
        if(!opllChannelEnabled[i])
        {
            if(lastOpllNoteOnOff[i])
            {
                Byte noteOnOff[] = { 0x80+opllMidiChannels[i], lastOpllNotes[i] ,0x40};
                status = [self sendMidiPacket:noteOnOff opllChannel:i size:3];
                lastOpllNoteOnOff[i] = opllNoteOnOff[i];
                                
                lastOpllNotes[i] = opllNotes[i];
            }
            continue;
        }
        
        if(opllInstruments[i]!=lastOpllInstruments[i])
        {
            dispatch_async(dispatch_get_main_queue(),^ {
                [[opllInstrumentsMatrix cellAtRow:0 column:i] selectItemAtIndex:opllInstruments[i]];
            });
            
            Byte programChange[2] = {0xc0+opllMidiChannels[i], gmSoundTable[opllInstruments[i]]};
            status = [self sendMidiPacket:programChange opllChannel:i size:2];
            
            lastOpllInstruments[i] = opllInstruments[i];
            opllNoteOnOff[i] = 0;
        }
        
        
        if(opllNoteOnOff[i])
        {
            if(!lastOpllNoteOnOff[i] || ((opllNotes[i] ^ lastOpllNotes[i])))// && difference > 1))
            {
                Byte noteOnOff[] = { 0x80+opllMidiChannels[i], lastOpllNotes[i] ,0x40,  0x90+opllMidiChannels[i] ,opllNotes[i] , opllVolumes[i]};
                status = [self sendMidiPacket:noteOnOff opllChannel:i size:6];
                lastOpllNoteOnOff[i] = opllNoteOnOff[i];
                
                lastOpllNotes[i] = opllNotes[i];
                continue;
            }
        }
        else
        {
            // Note Off
            if(opllNoteOnOff[i] ^ lastOpllNoteOnOff[i])
            {
                Byte noteOnOff[] = { 0x80+opllMidiChannels[i], lastOpllNotes[i] ,0x40};
                status = [self sendMidiPacket:noteOnOff opllChannel:i size:3];
                lastOpllNoteOnOff[i] = opllNoteOnOff[i];
                
                lastOpllNotes[i] = opllNotes[i];
                continue;
            }
        }
    }
    
}

- (OSStatus)sendMidiPacket:(Byte *)packet opllChannel:(int)channel size:(int)size
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
        for(int i =0 ; i<9; i++)
        {
            [[opllMidiPortsMatrix cellAtRow:0 column:i] removeAllItems];
        }
    });
    
    
    unsigned long numberOfDestination = MIDIGetNumberOfDestinations();
    if(numberOfDestination)
    {
        for(int i=0;i<numberOfDestination;i++)
        {
            myMidiDeviceRef = MIDIGetDestination(i);
            
            CFStringRef midiDeviceName;
            
            MIDIObjectGetStringProperty(myMidiDeviceRef, kMIDIPropertyName, &midiDeviceName);
            NSString *testDestination = (__bridge NSString *)midiDeviceName;
            
            dispatch_async(dispatch_get_main_queue(),^ {
                for(int j = 0 ; j < 9; j++)
                    [[opllMidiPortsMatrix cellAtRow:0 column:j] addItemWithTitle:testDestination];
            });
        }
    }
    
    for(int i=0;i<9;i++)
    {
        if(MIDIGetNumberOfDestinations())
        {
            lastMidiEndPointRef[i] = midiEndPointRef[i];
            midiEndPointRef[i] = MIDIGetDestination(0);
            [[opllMidiPortsMatrix cellAtRow:0 column:i] selectItemAtIndex:0];
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    //  NSLog(@"blablabla");
    
}

-(IBAction)setMidiPort:(id)sender
{
    int selectedColumn;
    int selectedRow;
    
    selectedRow = (int)[sender selectedRow];
    selectedColumn = (int)[sender selectedColumn];
    lastMidiEndPointRef[selectedColumn] = midiEndPointRef[selectedColumn];
    midiEndPointRef[selectedColumn] = MIDIGetDestination([[opllMidiPortsMatrix cellAtRow:selectedRow column:selectedColumn] indexOfSelectedItem]);
}



-(IBAction)panic:(id)sender
{
    for(int i=0; i<9;i++)
    {
        OSStatus status;
        Byte buffer[256];
        
        MIDIPacketList *myPacketList = (MIDIPacketList*)buffer;
        MIDIPacket *myPacket = MIDIPacketListInit(myPacketList);
        
        Byte lastNoteOff[3] = { 0x80+opllMidiChannels[i], lastOpllNotes[i] ,0x40};
        myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, 3, lastNoteOff);
        Byte noteOff[3] = { 0x80+opllMidiChannels[i], opllNotes[i] ,0x40};
        myPacket = MIDIPacketListAdd(myPacketList, sizeof(buffer), myPacket, timeStamp, 3, noteOff);
        
        if ((status = MIDISend(myMidiOutputPort, midiEndPointRef[i], myPacketList)))
        {
            printf("Problem\n");
            exit(status);
        }
    }
}

@end
