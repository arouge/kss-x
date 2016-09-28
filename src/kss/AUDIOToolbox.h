//
//  AUDIOToolbox.h
//  kss
//
//  Created by Valken on 08.10.13.
//
//

#import <Foundation/Foundation.h>
#import "ksstypes.h"

@interface AUDIOToolbox : NSObject
{
    
}
- (NSNumber *)convertFrequency:(NSNumber *)frequency deviceName:(NSInteger)deviceType;
- (NSString *)noteName:(NSNumber *)noteNumber;
char * int2bin(int i);
-(NSNumber *)timeDecomp:(NSString *)originalTime;

@end

