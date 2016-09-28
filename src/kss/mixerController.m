#import "mixerController.h"

@implementation mixerController

-(void)updateVolumes
{
	[masterVolume setIntValue:[[mixerKss masterVolume] intValue]];
	[psgVolume setIntValue:[[mixerKss psgVolume] intValue]];
	[sccVolume setIntValue:[[mixerKss sccVolume] intValue]];
	[oplVolume setIntValue:[[mixerKss oplVolume] intValue]];
	[opllVolume setIntValue:[[mixerKss opllVolume] intValue]];
	
	[masterVolumeValue setIntValue:[[mixerKss masterVolume] intValue]];
	[psgVolumeValue setIntValue:[[mixerKss psgVolume] intValue]];
	[sccVolumeValue setIntValue:[[mixerKss sccVolume] intValue]];
	[oplVolumeValue setIntValue:[[mixerKss oplVolume] intValue]];
	[opllVolumeValue setIntValue:[[mixerKss opllVolume] intValue]];
}

- (IBAction)resetVolumes:(id)sender
{	
	NSNumber *zero = [NSNumber numberWithInt:0];
	
	[mixerKss changeMasterVolume:zero];
	[mixerKss changePsgVolume:zero];
	[mixerKss changeSccVolume:zero];
	[mixerKss changeOplVolume:zero];
	[mixerKss changeOpllVolume:zero];
		
    [self updateVolumes];
}


- (void)awakeFromNib
{
	mixerKss = [[kssObject alloc] init];
	[self updateVolumes];
	
	//NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateVolumes) userInfo:nil repeats:YES];
}




- (IBAction)changeMasterVolume:(id)sender
{
	[mixerKss changeMasterVolume:[NSNumber numberWithInt:[sender intValue]]];
	[masterVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)changeOpllVolume:(id)sender
{
	[mixerKss changeOpllVolume:[NSNumber numberWithInt:[sender intValue]]];
	[opllVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)changeOplVolume:(id)sender
{
	[mixerKss changeOplVolume:[NSNumber numberWithInt:[sender intValue]]];
	[oplVolumeValue setIntValue:[sender intValue]];	
}

- (IBAction)changePsgVolume:(id)sender
{
	[mixerKss changePsgVolume:[NSNumber numberWithInt:[sender intValue]]];
	[psgVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)changeSccVolume:(id)sender
{
	[mixerKss changeSccVolume:[NSNumber numberWithInt:[sender intValue]]];
	[sccVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)muteOpl:(id)sender
{
	if([oplVolume isEnabled])
	{
		[oplVolume setEnabled:0];
		tempOplVolume = [oplVolume intValue];
		[mixerKss changeOplVolume:[NSNumber numberWithInt:-255]];
	}
	else
	{
		[oplVolume setEnabled:1];
		[mixerKss changeOplVolume:[NSNumber numberWithInt:tempOplVolume]];
	}
}

- (IBAction)muteOpll:(id)sender
{
	if([opllVolume isEnabled])
	{
		[opllVolume setEnabled:0];
		tempOpllVolume = [opllVolume intValue];
		[mixerKss changeOpllVolume:[NSNumber numberWithInt:-255]];
	}
	else
	{
		[opllVolume setEnabled:1];
		[mixerKss changeOpllVolume:[NSNumber numberWithInt:tempOpllVolume]];
	}
}

- (IBAction)mutePsg:(id)sender
{
	if([psgVolume isEnabled])
	{
		[psgVolume setEnabled:0];
		tempPsgVolume = [psgVolume intValue];
		[mixerKss changePsgVolume:[NSNumber numberWithInt:-255]];
	}
	else
	{
		[psgVolume setEnabled:1];
		[mixerKss changePsgVolume:[NSNumber numberWithInt:tempPsgVolume]];
	}
}

- (IBAction)muteScc:(id)sender
{
	if([sccVolume isEnabled])
	{
		[sccVolume setEnabled:0];
		tempSccVolume = [sccVolume intValue];
		[mixerKss changeSccVolume:[NSNumber numberWithInt:-255]];
	}
	else
	{
		[sccVolume setEnabled:1];
		[mixerKss changeSccVolume:[NSNumber numberWithInt:tempSccVolume]];
	}
}

- (IBAction)panPsg:(id)sender
{
	[mixerKss setPsgPan:[NSNumber numberWithInt:1]];
	printf("test\n");
}

- (IBAction)panScc:(id)sender
{

}

- (IBAction)panOpl:(id)sender
{

}

- (IBAction)panOpll:(id)sender
{

}

@end
