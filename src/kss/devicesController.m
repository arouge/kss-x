#import "devicesController.h"

@implementation devicesController


//-(void)awakeFromNib
- (void)windowDidLoad
{

	devicesKss = [[kssObject alloc] init];
	[devicesChange setSelectionByRect:YES];
    
	psgMask = [devicesKss psgMask];
	sccMask = [devicesKss sccMask];
	oplMask = [devicesKss oplMask];
	opllMask = [devicesKss opllMask];
    
    dispatch_async(dispatch_get_main_queue(),^ {
        int i =0;
        for(i=0; i<6;i++)
        {
            int result = pow((double)2,(double)i);
            [[devicesChange cellAtRow:0 column:i] setState:!([devicesKss psgMask] &result)];
        }
    });
    dispatch_async(dispatch_get_main_queue(),^ {
        int i =0;
        for(i=0; i<5;i++)
        {
            int result = pow((double)2,(double)i);
            [[devicesChange cellAtRow:1 column:i] setState:!([devicesKss sccMask] &result)];
        }
    });
    dispatch_async(dispatch_get_main_queue(),^ {
        int i =0;
        for(i=0; i<9;i++)
        {
            int result = pow((double)2,(double)i);
            [[devicesChange cellAtRow:2 column:i] setState:!([devicesKss oplMask] &result)];
        }
    });
    dispatch_async(dispatch_get_main_queue(),^ {
        int i =0;
        for(i=0; i<14;i++)
        {
            int result = pow((double)2,(double)i);
            [[devicesChange cellAtRow:3 column:i] setState:!([devicesKss opllMask] &result)];
        }
    });
  
} 

- (IBAction)devicesOpllPan:(id)sender
{
    NSInteger selectedColumn;
	
	selectedColumn = [sender selectedColumn];
    [devicesKss setOpllPan:selectedColumn value:[sender intValue]];
    
}

- (IBAction)devicesChange:(id)sender
{
	NSInteger selectedColumn;
    NSInteger selectedRow;
	
	selectedRow = [sender selectedRow];
	selectedColumn = [sender selectedColumn];
	
	if(selectedRow==0)
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            psgMask = psgMask - (1<<selectedColumn);
        else
            psgMask = psgMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:psgMask forKey:@"psgMask"];
        
        [devicesKss setPsgMask:psgMask];
	}
	
	if(selectedRow==1)//SCC Device
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            sccMask = sccMask - (1<<selectedColumn);
        else
            sccMask = sccMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:sccMask forKey:@"sccMask"];
        [devicesKss setSccMask:sccMask];
	}
	
	if(selectedRow==2)// Opl
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            oplMask = oplMask - (1<<selectedColumn);
        else
            oplMask = oplMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:oplMask forKey:@"oplMask"];
        [devicesKss setOplMask:oplMask];
	}
	
	if(selectedRow==3)//OPLL
	{
        if([[devicesChange cellAtRow:selectedRow column:selectedColumn] state])
            opllMask = opllMask - (1<<selectedColumn);
        else
            opllMask = opllMask + (1<<selectedColumn);
        [[devicesChange cellAtRow:selectedRow column:selectedColumn] setState:![[devicesChange cellAtRow:selectedRow column:selectedRow] state]];
        
        [devicesKss setOpllMask:opllMask];
    }
}

- (IBAction)devicesPsgInvert:(id)sender
{
    psgMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i<6;i++)
        {
            [[devicesChange cellAtRow:0 column:i] setState:![[devicesChange cellAtRow:0 column:i] state]];
            psgMask = psgMask + pow(2,i)*![[devicesChange cellAtRow:0 column:i] state];
        }
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:psgMask forKey:@"psgMask"];

	[devicesKss setPsgMask:psgMask];
    
    

        
    });
}

- (IBAction)devicesSccInvert:(id)sender
{
    sccMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i<5;i++)
        {
            [[devicesChange cellAtRow:1 column:i] setState:![[devicesChange cellAtRow:1 column:i] state]];
            sccMask = sccMask + pow(2,i)*![[devicesChange cellAtRow:1 column:i] state];
        }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:sccMask forKey:@"sccMask"];
        
	[devicesKss setSccMask:sccMask];
    });
}

- (IBAction)devicesOplInvert:(id)sender
{
    oplMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i<9;i++)
        {
            [[devicesChange cellAtRow:2 column:i] setState:![[devicesChange cellAtRow:2 column:i] state]];
            oplMask = oplMask + pow(2,i)*![[devicesChange cellAtRow:2 column:i] state];
        }
        
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:oplMask forKey:@"oplMask"];
    
	[devicesKss setOplMask:oplMask];
        });
}

- (IBAction)devicesOpllInvert:(id)sender
{
    opllMask = 0;
    dispatch_async(dispatch_get_main_queue(),^ {
        for(int i=0; i<14;i++)
        {
            [[devicesChange cellAtRow:3 column:i] setState:![[devicesChange cellAtRow:3 column:i] state]];
            opllMask = opllMask + pow(2,i)*![[devicesChange cellAtRow:3 column:i] state];
        }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:opllMask forKey:@"opllMask"];
        
	[devicesKss setOpllMask:opllMask];
        });
}

@end
