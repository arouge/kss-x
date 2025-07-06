//
//  AUDIOToolbox.m
//  kss
//
//  Created by Valken on 08.10.13.
//
//

#import "AUDIOToolbox.h"
#import <limits.h>
#import "kss.h"

@implementation AUDIOToolbox

- (NSNumber *)convertFrequency:(NSNumber *)frequency deviceName:(NSInteger)deviceType
{
    double naturalNote=0;
    double frequence=0;
    
    if(![frequency intValue])
        return 0;
    if(deviceType==EDSC_PSG)
        frequence = (3579545/32)/([frequency intValue]);
    if(deviceType==EDSC_SCC)
        frequence = (3579545)/(32*[frequency intValue]+1);
    //if(deviceType==EDSC_OPL)
    if(deviceType==EDSC_OPLL)
    {
        frequence = [frequency longLongValue];
    }
    
    if(frequence>=16)
    {
        double loga;
        loga = log(pow(2, 1/12.0));
        double r3 = log(440)/loga -69;
        naturalNote = log(frequence)/loga - r3;
    }
    return [NSNumber numberWithInt:(int)round(naturalNote)];
}

- (NSString *)noteName:(NSNumber *)noteNumber
{
    int reste;
    int octave;
    char* notes[12] = {"C", "C#","D","D#","E","F","F#","G","G#","A","A#","B"};

    reste = [noteNumber intValue] % 12;
    octave = [noteNumber intValue] / 12;
    
    NSString *noteName = [NSString stringWithUTF8String:notes[reste]] ;
    noteName = [noteName stringByAppendingString:[[NSNumber numberWithInt:octave] stringValue]];
    return noteName;
}


-(NSInteger)timeDecomp:(NSString *)originalTime
{
    if([originalTime length])
    {
        NSArray *timeElements;
        NSInteger numberOfItems;
        int total=0;
        timeElements = [originalTime componentsSeparatedByString:@":"];
    
        numberOfItems = [timeElements count];
    
        for(int i=0 ; i<numberOfItems ;i++)
        {
            total = total + [[timeElements objectAtIndex:numberOfItems-i-1] intValue] * pow(60,i);
        }
        return  total;
    }
    return 0;
}

@end
