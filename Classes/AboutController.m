#import "AboutController.h"

@implementation AboutController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName: nibName bundle: nibBundle];
	[self setTitle:@"About"];
	
	return self;
}

- (IBAction) visitHomepage:(id)sender
{
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"http://www.fluxforge.com/"]];
}


- (IBAction) mailSupport:(id)sender
{
	[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"mailto:support@fluxforge.com?subject=EvE%20Trader%20support"]];
}

@end
