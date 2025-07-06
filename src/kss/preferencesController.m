#import "preferencesController.h"

@implementation preferencesController

- (void)awakeFromNib
{
	anotherKSS = [[kssObject alloc] init];
    myAudioToolbox = [[AUDIOToolbox alloc] init];
    
	/*switch([[anotherKSS bufferSize] intValue])
	{ 
		case 2048:{[bufferPopUp selectItemAtIndex:0]; break ;}
		case 4096:{[bufferPopUp selectItemAtIndex:1]; break ;}
		case 8192:{[bufferPopUp selectItemAtIndex:2]; break ;}
	}
    */
    dispatch_async(dispatch_get_main_queue(),^ {
	switch([anotherKSS frameRate])
	{ 
		case 22050:{[sampleRate selectItemAtIndex:0];break ;}
		case 44100:{[sampleRate selectItemAtIndex:1];break ;}
		case 111861:{[sampleRate selectItemAtIndex:2];break ;}
	}
    });
    dispatch_async(dispatch_get_main_queue(),^ {
        [preferencesVdpSpeed addItemWithTitle:@"Auto"];
        [preferencesVdpSpeed addItemWithTitle:@"60 Hz"];
        [preferencesVdpSpeed addItemWithTitle:@"50 Hz"];
        [preferencesVdpSpeed addItemWithTitle:@"40 Hz"];
        [preferencesVdpSpeed addItemWithTitle:@"30 Hz"];
        [preferencesVdpSpeed addItemWithTitle:@"20 Hz"];
        [preferencesVdpSpeed addItemWithTitle:@"10 Hz"];
	switch([anotherKSS getVdpSpeed ])
	{
		case 0:{[preferencesVdpSpeed selectItemAtIndex:0];break ;}
		case 60:{[preferencesVdpSpeed selectItemAtIndex:1];break ;}
		case 50:{[preferencesVdpSpeed selectItemAtIndex:2];break ;}
        case 40:{[preferencesVdpSpeed selectItemAtIndex:3];break ;}
        case 30:{[preferencesVdpSpeed selectItemAtIndex:4];break ;}
        case 20:{[preferencesVdpSpeed selectItemAtIndex:5];break ;}
        case 10:{[preferencesVdpSpeed selectItemAtIndex:6];break ;}
            
	}
    });
    dispatch_async(dispatch_get_main_queue(),^ {
	switch([anotherKSS	getCpuSpeed])
	{
		case 1:{[preferencesCpuSpeed selectItemAtIndex:0]; break;}
		case 2:{[preferencesCpuSpeed selectItemAtIndex:1]; break;}
	}
    });
    // Set defaultTime using proper display layout
    NSString *myTime;
    myTime = [NSString stringWithFormat: @"%ld:%02ld:%02ld",([anotherKSS defaultPlayTime] / (60 * 60)),([anotherKSS defaultPlayTime] / 60 % 60),([anotherKSS defaultPlayTime] % 60)];
    dispatch_async(dispatch_get_main_queue(),^ {
        [defaultPlayTimeOutlet setStringValue:myTime];});
}

- (IBAction)apply:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
	switch([sampleRate indexOfSelectedItem])
	{
        case 0:
            [anotherKSS setFrameRate:22050];
            break;
        case 1:[anotherKSS setFrameRate:44100];
            break;
        case 2:[anotherKSS setFrameRate:111861];
            break;
	}
    });
}

/*- (IBAction)setBufferSize:(id)sender
{

	switch([bufferPopUp indexOfSelectedItem])
	{
		case 0:{ [anotherKSS setBufferSize:[NSNumber numberWithInt:2048]]; break;}
		case 1:{ [anotherKSS setBufferSize:[NSNumber numberWithInt:4096]]; break;}
		case 2:{ [anotherKSS setBufferSize:[NSNumber numberWithInt:8192]]; break;}
	}
	//[anotherKSS savePreferences];
}
*/

- (IBAction)setVdpSpeed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
	switch([preferencesVdpSpeed indexOfSelectedItem])
	{
		case 0:{ [anotherKSS setVdpSpeed:0]; break;}
		case 1:{ [anotherKSS setVdpSpeed:60]; break;}
        case 2:{ [anotherKSS setVdpSpeed:50]; break;}
        case 3:{ [anotherKSS setVdpSpeed:40]; break;}
        case 4:{ [anotherKSS setVdpSpeed:30]; break;}
        case 5:{ [anotherKSS setVdpSpeed:20]; break;}
        case 6:{ [anotherKSS setVdpSpeed:10]; break;}
	}
    });
}

- (IBAction)setCpuSpeed:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
	[anotherKSS setCpuSpeed:[preferencesCpuSpeed indexOfSelectedItem]];
    //    [anotherKSS setCpuSpeed:[preferencesCpuSpeed indexOfSelectedItem]];

    });
}

- (IBAction)setDefaultPlayTime:(id)sender
{
    [anotherKSS setDefaultPlayTime:[myAudioToolbox timeDecomp:[defaultPlayTimeOutlet stringValue]]];
    
    NSString *myTime;
    myTime = [NSString stringWithFormat: @"%ld:%02ld:%02ld",([anotherKSS defaultPlayTime] / (60 * 60)),([anotherKSS defaultPlayTime] / 60 % 60),([anotherKSS defaultPlayTime] % 60)];
    dispatch_async(dispatch_get_main_queue(),^ {
        [defaultPlayTimeOutlet setStringValue:myTime];
    });
}

@end
