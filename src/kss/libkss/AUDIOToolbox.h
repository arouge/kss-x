//
//  AUDIOToolbox.h
//  kss
//
//  Created by Valken on 08.10.13.
//
//

#import <Foundation/Foundation.h>
//#import "ksstypes.h"

@interface AUDIOToolbox : NSObject
{
    
}
- (NSNumber *)convertFrequency:(NSNumber *)frequency deviceName:(NSInteger)deviceType;
- (NSString *)noteName:(NSNumber *)noteNumber;
-(NSInteger)timeDecomp:(NSString *)originalTime;

@end

