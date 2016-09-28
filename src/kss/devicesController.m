#import "devicesController.h"

@implementation devicesController

-(void)awakeFromNib
{
	devicesKss = [[kssObject alloc] init];
	[devicesChange setSelectionByRect:YES];
	
	psgMask = 0;
	sccMask = 0;
	oplMask = 0;
	opllMask = 0;
} 

- (IBAction)devicesOpllPan:(id)sender
{
	int selectedColumn;
	
	selectedColumn = [sender selectedColumn];
        [devicesKss setOpllPan:[NSNumber numberWithInt:selectedColumn] value:[NSNumber numberWithInt:[sender intValue]]];
    
}

- (IBAction)devicesChange:(id)sender
{
	int selectedColumn;
	int selectedRow;
	
	selectedRow = [sender selectedRow];
	selectedColumn = [sender selectedColumn];
	
	if(selectedRow==0)
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            psgMask = psgMask - (1<<selectedColumn);
        else
            psgMask = psgMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
           
        [devicesKss setPsgMask:[NSNumber numberWithInt:psgMask]];
	}
	
	if(selectedRow==1)//SCC Device
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            sccMask = sccMask - (1<<selectedColumn);
        else
            sccMask = sccMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        
        [devicesKss setSccMask:[NSNumber numberWithInt:sccMask]];
	}
	
	if(selectedRow==2)// Opl
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            oplMask = oplMask - (1<<selectedColumn);
        else
            oplMask = oplMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        [devicesKss setOplMask:[NSNumber numberWithInt:oplMask]];
	}
	
	if(selectedRow==3)//OPLL
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            opllMask = opllMask - (1<<selectedColumn);
        else
            opllMask = opllMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        
        [devicesKss setOpllMask:[NSNumber numberWithInt:opllMask]];
    }
}

- (IBAction)devicesPsgInvert:(id)sender
{
    psgMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
    [[devicesChange cellAtRow:0 column:0] setState:![[devicesChange cellAtRow:0 column:0] state]];
    [[devicesChange cellAtRow:0 column:1] setState:![[devicesChange cellAtRow:0 column:1] state]];
    [[devicesChange cellAtRow:0 column:2] setState:![[devicesChange cellAtRow:0 column:2] state]];
    [[devicesChange cellAtRow:0 column:3] setState:![[devicesChange cellAtRow:0 column:3] state]];
    [[devicesChange cellAtRow:0 column:4] setState:![[devicesChange cellAtRow:0 column:4] state]];
    [[devicesChange cellAtRow:0 column:5] setState:![[devicesChange cellAtRow:0 column:5] state]];
    
    
    psgMask = psgMask + ![[devicesChange cellAtRow:0 column:0] state];
    psgMask = psgMask + 2*![[devicesChange cellAtRow:0 column:1] state];
    psgMask = psgMask + 4*![[devicesChange cellAtRow:0 column:2] state];
    psgMask = psgMask + 8*![[devicesChange cellAtRow:0 column:3] state];
    psgMask = psgMask + 16*![[devicesChange cellAtRow:0 column:4] state];
    psgMask = psgMask + 32*![[devicesChange cellAtRow:0 column:5] state];
    
	[devicesKss setPsgMask:[NSNumber numberWithInt:psgMask]];
    });
}

- (IBAction)devicesSccInvert:(id)sender
{
    sccMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
    [[devicesChange cellAtRow:1 column:0] setState:![[devicesChange cellAtRow:1 column:0] state]];
    [[devicesChange cellAtRow:1 column:1] setState:![[devicesChange cellAtRow:1 column:1] state]];
    [[devicesChange cellAtRow:1 column:2] setState:![[devicesChange cellAtRow:1 column:2] state]];
    [[devicesChange cellAtRow:1 column:3] setState:![[devicesChange cellAtRow:1 column:3] state]];
    [[devicesChange cellAtRow:1 column:4] setState:![[devicesChange cellAtRow:1 column:4] state]];
    sccMask = sccMask + ![[devicesChange cellAtRow:1 column:0] state];
    sccMask = sccMask + 2*![[devicesChange cellAtRow:1 column:1] state];
    sccMask = sccMask + 4*![[devicesChange cellAtRow:1 column:2] state];
    sccMask = sccMask + 8*![[devicesChange cellAtRow:1 column:3] state];
    sccMask = sccMask + 16*![[devicesChange cellAtRow:1 column:4] state];
    
	[devicesKss setSccMask:[NSNumber numberWithInt:sccMask]];
    });
}

- (IBAction)devicesOplInvert:(id)sender
{
    oplMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
    [[devicesChange cellAtRow:2 column:0] setState:![[devicesChange cellAtRow:2 column:0] state]];
    [[devicesChange cellAtRow:2 column:1] setState:![[devicesChange cellAtRow:2 column:1] state]];
    [[devicesChange cellAtRow:2 column:2] setState:![[devicesChange cellAtRow:2 column:2] state]];
    [[devicesChange cellAtRow:2 column:3] setState:![[devicesChange cellAtRow:2 column:3] state]];
    [[devicesChange cellAtRow:2 column:4] setState:![[devicesChange cellAtRow:2 column:4] state]];
    [[devicesChange cellAtRow:2 column:5] setState:![[devicesChange cellAtRow:2 column:5] state]];
    [[devicesChange cellAtRow:2 column:6] setState:![[devicesChange cellAtRow:2 column:6] state]];
    [[devicesChange cellAtRow:2 column:7] setState:![[devicesChange cellAtRow:2 column:7] state]];
    [[devicesChange cellAtRow:2 column:8] setState:![[devicesChange cellAtRow:2 column:8] state]];
    
    oplMask = oplMask + ![[devicesChange cellAtRow:2 column:0] state];
    oplMask = oplMask + 2*![[devicesChange cellAtRow:2 column:1] state];
    oplMask = oplMask + 4*![[devicesChange cellAtRow:2 column:2] state];
    oplMask = oplMask + 8*![[devicesChange cellAtRow:2 column:3] state];
    oplMask = oplMask + 16*![[devicesChange cellAtRow:2 column:4] state];
    oplMask = oplMask + 32*![[devicesChange cellAtRow:2 column:5] state];
    oplMask = oplMask + 64*![[devicesChange cellAtRow:2 column:6] state];
    oplMask = oplMask + 128*![[devicesChange cellAtRow:2 column:7] state];
    oplMask = oplMask + 256*![[devicesChange cellAtRow:2 column:8] state];
    
	[devicesKss setOplMask:[NSNumber numberWithInt:oplMask]];
        });
}

- (IBAction)devicesOpllInvert:(id)sender
{
    opllMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
    [[devicesChange cellAtRow:3 column:0] setState:![[devicesChange cellAtRow:3 column:0] state]];
    [[devicesChange cellAtRow:3 column:1] setState:![[devicesChange cellAtRow:3 column:1] state]];
    [[devicesChange cellAtRow:3 column:2] setState:![[devicesChange cellAtRow:3 column:2] state]];
    [[devicesChange cellAtRow:3 column:3] setState:![[devicesChange cellAtRow:3 column:3] state]];
    [[devicesChange cellAtRow:3 column:4] setState:![[devicesChange cellAtRow:3 column:4] state]];
    [[devicesChange cellAtRow:3 column:5] setState:![[devicesChange cellAtRow:3 column:5] state]];
    [[devicesChange cellAtRow:3 column:6] setState:![[devicesChange cellAtRow:3 column:6] state]];
    [[devicesChange cellAtRow:3 column:7] setState:![[devicesChange cellAtRow:3 column:7] state]];
    [[devicesChange cellAtRow:3 column:8] setState:![[devicesChange cellAtRow:3 column:8] state]];
    
    // Drums channels
    [[devicesChange cellAtRow:3 column:9] setState:![[devicesChange cellAtRow:3 column:9] state]];
    [[devicesChange cellAtRow:3 column:10] setState:![[devicesChange cellAtRow:3 column:10] state]];
    [[devicesChange cellAtRow:3 column:11] setState:![[devicesChange cellAtRow:3 column:11] state]];
    [[devicesChange cellAtRow:3 column:12] setState:![[devicesChange cellAtRow:3 column:12] state]];
    [[devicesChange cellAtRow:3 column:13] setState:![[devicesChange cellAtRow:3 column:13] state]];
    
    opllMask = opllMask + ![[devicesChange cellAtRow:3 column:0] state];
    opllMask = opllMask + 2*![[devicesChange cellAtRow:3 column:1] state];
    opllMask = opllMask + 4*![[devicesChange cellAtRow:3 column:2] state];
    opllMask = opllMask + 8*![[devicesChange cellAtRow:3 column:3] state];
    opllMask = opllMask + 16*![[devicesChange cellAtRow:3 column:4] state];
    opllMask = opllMask + 32*![[devicesChange cellAtRow:3 column:5] state];
    opllMask = opllMask + 64*![[devicesChange cellAtRow:3 column:6] state];
    opllMask = opllMask + 128*![[devicesChange cellAtRow:3 column:7] state];
    opllMask = opllMask + 256*![[devicesChange cellAtRow:3 column:8] state];
    
    opllMask = opllMask + 512*![[devicesChange cellAtRow:3 column:9] state];
    opllMask = opllMask + 1024*![[devicesChange cellAtRow:3 column:10] state];
    opllMask = opllMask + 2048*![[devicesChange cellAtRow:3 column:11] state];
    opllMask = opllMask + 4096*![[devicesChange cellAtRow:3 column:12] state];
    opllMask = opllMask + 8192*![[devicesChange cellAtRow:3 column:13] state];
    
	[devicesKss setOpllMask:[NSNumber numberWithInt:opllMask]];
        });
}

@end
