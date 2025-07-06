#import "aboutWindow.h"

@implementation aboutWindow

- (void)awakeFromNib
{	
	NSMutableAttributedString *creditsString;
	NSString *creditsPath;
			        
	creditsPath = [[NSBundle mainBundle] pathForResource:@"credits" ofType:@"rtf"];

	creditsString = [[NSMutableAttributedString alloc] initWithPath:creditsPath documentAttributes:nil];
	[[self window] center];
	
	[textOutlet replaceCharactersInRange:NSMakeRange( 0, 0 ) withRTF:[creditsString RTFFromRange: NSMakeRange( 0, [creditsString length] ) documentAttributes:nil]];
	[creditsString release];
}

- (IBAction)aboutCloseWindow:(id)sender
{
	[[self window] close];
}

@end
