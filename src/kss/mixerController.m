#import "mixerController.h"

@implementation mixerController

-(void)updateVolumes
{
	[masterVolume setIntValue:(int)[mixerKss masterVolume]];
	[psgVolume setIntValue:(int)[mixerKss psgVolume]];
	[sccVolume setIntValue:(int)[mixerKss sccVolume]];
	[oplVolume setIntValue:(int)[mixerKss oplVolume]];
	[opllVolume setIntValue:(int)[mixerKss opllVolume]];
	
	[masterVolumeValue setIntValue:(int)[mixerKss masterVolume]];
	[psgVolumeValue setIntValue:(int)[mixerKss psgVolume]];
	[sccVolumeValue setIntValue:(int)[mixerKss sccVolume]];
	[oplVolumeValue setIntValue:(int)[mixerKss oplVolume]];
	[opllVolumeValue setIntValue:(int)[mixerKss opllVolume]];
}

- (IBAction)resetVolumes:(id)sender
{	
	
	[mixerKss changeMasterVolume:0];
	[mixerKss changePsgVolume:0];
	[mixerKss changeSccVolume:0];
	[mixerKss changeOplVolume:0];
	[mixerKss changeOpllVolume:0];
		
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
	[mixerKss changeMasterVolume:[sender intValue]];
	[masterVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)changeOpllVolume:(id)sender
{
	[mixerKss changeOpllVolume:[sender intValue]];
	[opllVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)changeOplVolume:(id)sender
{
	[mixerKss changeOplVolume:[sender intValue]];
	[oplVolumeValue setIntValue:[sender intValue]];	
}

- (IBAction)changePsgVolume:(id)sender
{
	[mixerKss changePsgVolume:[sender intValue]];
	[psgVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)changeSccVolume:(id)sender
{
	[mixerKss changeSccVolume:[sender intValue]];
	[sccVolumeValue setIntValue:[sender intValue]];
}

- (IBAction)muteOpl:(id)sender
{
	if([oplVolume isEnabled])
	{
		[oplVolume setEnabled:0];
		tempOplVolume = [oplVolume intValue];
		[mixerKss changeOplVolume:-255];
	}
	else
	{
		[oplVolume setEnabled:1];
		[mixerKss changeOplVolume:tempOplVolume];
	}
}

- (IBAction)muteOpll:(id)sender
{
	if([opllVolume isEnabled])
	{
		[opllVolume setEnabled:0];
		tempOpllVolume = [opllVolume intValue];
		[mixerKss changeOpllVolume:-255];
	}
	else
	{
		[opllVolume setEnabled:1];
		[mixerKss changeOpllVolume:tempOpllVolume];
	}
}

- (IBAction)mutePsg:(id)sender
{
	if([psgVolume isEnabled])
	{
		[psgVolume setEnabled:0];
		tempPsgVolume = [psgVolume intValue];
		[mixerKss changePsgVolume:-255];
	}
	else
	{
		[psgVolume setEnabled:1];
		[mixerKss changePsgVolume:tempPsgVolume];
	}
}

- (IBAction)muteScc:(id)sender
{
	if([sccVolume isEnabled])
	{
		[sccVolume setEnabled:0];
		tempSccVolume = [sccVolume intValue];
		[mixerKss changeSccVolume:-255];
	}
	else
	{
		[sccVolume setEnabled:1];
		[mixerKss changeSccVolume:tempSccVolume];
	}
}

- (IBAction)panPsg:(id)sender
{
	[mixerKss setPsgPan:1];
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
