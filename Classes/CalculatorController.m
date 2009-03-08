#import "CalculatorController.h"

@implementation CalculatorController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName: nibName bundle: nibBundle];
	[self setTitle:@"Calculator"];
	
//	[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"brokersFee" options:NSKeyValueObservingOptionNew context: NULL];
//	[[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"salesTax" options:NSKeyValueObservingOptionNew context: NULL];
	

	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(updateFeeCalculations:) name:@"profileChanged" object:nil];
	
	return self;
}

- (void) updateFeeCalculations: (NSNotification *)notification
{
	NSLog(@"profileChanged! %@",notification);
	[self calculateBrokersFeeAndSalesTax];
	
}

- (void) keyboardWillShowNotification: (NSNotification *)notification
{
	//NSLog(@"omg they did show!");	
	[self showHideKeypadButton: YES];
}
- (void) UIKeyboardWillHideNotification: (NSNotification *)notification
{
	//NSLog(@"omg keyboard will hide!");	
	[self showHideKeypadButton: NO];
}

- (void) hideKeypad: (id) sender
{
	[sellPriceInput resignFirstResponder];
	[buyPriceInput resignFirstResponder];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"willHideKeyboard" object: nil];
}

- (void) selectNextTextfield: (id) sender
{
	[nextTextfieldButton setEnabled: YES];
	[nextTextfieldButton setHighlighted: YES];

	if ([buyPriceInput isEditing])
	{	
		[sellPriceInput becomeFirstResponder];

	}
	else if ([sellPriceInput isEditing])
		[self doCalc: self];
}

- (void) showHideKeypadButton: (BOOL) showButton
{
	//NSLog(@"%i",showButton);
	if (showButton)
	{
		
		[ UIView beginAnimations: nil context: nil ]; // Tell UIView we're ready to start animations.
		[ UIView setAnimationDuration: 0.2f ]; // Set the duration to 4/10ths of a second.

		[hideKeypadButton setAlpha: 1.0f];
		[nextTextfieldButton setAlpha: 1.0f];
		
		[ UIView commitAnimations ]; // Animate!
	}
	else
	{
		[ UIView beginAnimations: nil context: nil ]; // Tell UIView we're ready to start animations.
		[ UIView setAnimationDuration: 0.2f ]; // Set the duration to 4/10ths of a second.

		[hideKeypadButton setAlpha: 0.0f];
		[nextTextfieldButton setAlpha: 0.0f];

		[ UIView commitAnimations ]; // Animate!
	}
}

- (void)viewDidLoad
{
	//[webView setHidden: YES];
	NSString *s = [NSString stringWithString:@"<html><head></head><body style='background-color: transparent; color: white;'><p>&nbsp;&nbsp;&nbsp;&nbsp;</p><center><hr><h2>Welcome to EvE Trader</h2><hr></center></body></html>"];
	
	[webView setOpaque: NO];
	[webView setBackgroundColor: [UIColor clearColor]];
	[webView setAlpha: 1.0f];
	[webView setScalesPageToFit: NO];
	[webView setDetectsPhoneNumbers: NO];
	[webView loadHTMLString:s baseURL: nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"profileChanged" object: nil];
	
}

- (void)viewWillAppear:(BOOL)animated
{
	//NSLog(@"will appear!");
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(UIKeyboardWillHideNotification:) name:@"willHideKeyboard" object:nil];
	
	//[self showHideKeypadButton: NO];
	[self hideKeypad: self];
	
	//load salesTax and brokersFee to Labels
	//[self calculateBrokersFeeAndSalesTax];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self hideKeypad: self];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name:@"willHideKeyboard" object:nil];	
}


- (void) calculateBrokersFeeAndSalesTax
{
	NSString *activeProfileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];

	float brokerRelations = 0.0f;
	float accounting = 0.0f;
	float corpStanding = 0.0f;
	float factionStanding = 0.0f;

	
	for (NSMutableDictionary *profile in profiles)
	{
		if ([activeProfileName isEqualToString: [profile objectForKey:@"name"]])
		{
			NSLog(@"%@",profile);
			
			brokerRelations = [[profile valueForKey:@"brokerRelations"] floatValue];
			accounting = [[profile valueForKey:@"accounting"] floatValue];
			corpStanding = [[profile valueForKey:@"corpStanding"] floatValue];
			factionStanding = [[profile valueForKey:@"factionStanding"] floatValue];
		}
	}
	
	
	float totalSalesTax = 1.0 - (accounting*0.1);
	
	float e = 2.71828183;
	float bfe_part1 = pow(e,(-0.1000 * factionStanding));
	float bfe_part2 = pow (e,(-0.0400 * corpStanding));
	
	float brokers_fee_percentage = (1.000 - 0.05*brokerRelations) * bfe_part1 * bfe_part2;

	brokersFee = brokers_fee_percentage;
	salesTax = totalSalesTax;
	
	[self updateLabels];
	
}

- (void) updateLabels
{
	//NSLog(@"Updating Labels!");
	
	//float brokersFee = [[NSUserDefaults standardUserDefaults] floatForKey:@"brokersFee"];
	//float salesTax = [[NSUserDefaults standardUserDefaults] floatForKey:@"salesTax"];
	
	NSString *newCaption = [NSString stringWithFormat: @"%.4f %%", salesTax];
	[salesTaxLabel setText: newCaption];

	newCaption = [NSString stringWithFormat: @"%.4f %%", brokersFee];
	[brokersFeeLabel setText: newCaption];
	
    NSString *activeProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
	NSString *activeProfileString = [NSString stringWithFormat:@"Active Profile: %@",activeProfile];
	
	[activeProfileLabel setText: activeProfileString];
}

- (IBAction)doCalc:(id)sender
{
   	//[sellPriceInput resignFirstResponder];
	//[buyPriceInput resignFirstResponder];
	
	[self hideKeypad: self];

//	float brokersFeeRate = [[NSUserDefaults standardUserDefaults] floatForKey:@"brokersFee"];
//	float salesTaxRate = [[NSUserDefaults standardUserDefaults] floatForKey:@"salesTax"];
	
	float brokersFeeRate = brokersFee;
	float salesTaxRate = salesTax;
	
	float buyPrice = [[buyPriceInput text] floatValue];
	float sellPrice = [[sellPriceInput text] floatValue];
	
	
	float totalSalesTax = (salesTaxRate/100.0f) * sellPrice;
	
	float brokersFeeForBuy = (brokersFeeRate/100.0f) * buyPrice;
	float brokersFeeForSell = (brokersFeeRate/100.0f) * sellPrice;
	
	float totalBuyPrice = buyPrice + brokersFeeForBuy;
	float totalSellPrice = sellPrice - totalSalesTax - brokersFeeForSell;
	
	float winloss = totalSellPrice - totalBuyPrice;
	
	NSMutableString *s = [[[NSMutableString alloc] initWithString:	@"<html><head><title>Results</title></head><body style='background-color: transparent; color: white;'>"] autorelease];
	
	[s appendString:@"<table width=98%% rows=3 columns=2 border=0>"];
	[s appendString:@"<tr><td>Buy:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='red'>%.2f</font> ISK",buyPrice]];
	[s appendString:@"</td></tr>"];
	[s appendString:@"<tr><td>Sell:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='green'>%.2f</font> ISK",sellPrice]];
	[s appendString:@"</td></tr>"];
	
	[s appendString:@"<tr><td>Diff:</td><td align=right>"];	
	if (sellPrice-buyPrice > 0.0f)
		[s appendString:[NSString stringWithFormat:@"<font color='green'>%.2f</font> ISK",sellPrice-buyPrice]];
	else
		[s appendString:[NSString stringWithFormat:@"<font color='red'>%.2f</font> ISK",sellPrice-buyPrice]];
	
	[s appendString:@"</td></tr>"];
	
	[s appendString:@"</table>"];
	
	[s appendString:@"<hr>"];
	
	[s appendString:@"<table width=98%% rows=3 columns=2 border=0>"];
	[s appendString:@"<tr><td>Broker's Fee:</td><td align=right>"];
	[s appendString:[NSString stringWithFormat:@"<font color='red'>%.2f</font> ISK",brokersFeeForBuy+brokersFeeForSell]];
	[s appendString:@"<tr><td>Sales Tax:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='red'>%.2f</font> ISK",totalSalesTax]];
	[s appendString:@"</td></tr>"];	 
	[s appendString:@"<tr><td>Total:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='red'>%.2f</font> ISK",totalSalesTax+brokersFeeForBuy+brokersFeeForSell]];
	[s appendString:@"</td></tr>"];	 
	[s appendString:@"</table>"];
	
	[s appendString:@"<hr>"];
	
	[s appendString:@"<table width=98%% rows=1 columns=2 border=0>"];
	[s appendString:@"<tr><td>Net win/loss:</td><td align=right>"];
	if (winloss > 0.0)
		[s appendString:[NSString stringWithFormat:@"<font color='green'>+%.2f</font> ISK",winloss]];		
	else
		[s appendString:[NSString stringWithFormat:@"<font color='red'>%.2f</font> ISK",winloss]];		
	[s appendString:@"</td></tr>"];	 
	[s appendString:@"</table>"];
	
	
	[s appendString:@"</body></html>"];
	
	[webView loadHTMLString:s baseURL: nil];
	
}


- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
	/* if (aTextField == inputField)
	 {
	 // The return key is set to Done, so hide the keyboard
	 [inputField resignFirstResponder];
	 }*/
	
/*	if (aTextField == buyPriceInput)
	{
		[sellPriceInput becomeFirstResponder];
		return NO;
	}
	
	if (aTextField == sellPriceInput)
	{
		//[calcButton becomeFirstResponder];
		//[aTextField resignFirstResponder];
		//[self hideKeypad: self];
		[self doCalc: self];
	//	return NO;
	}
*/	
	return YES;
}

@end
