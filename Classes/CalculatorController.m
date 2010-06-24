#import "CalculatorController.h"
#import "NSString+Additions.h"

@implementation CalculatorController
@synthesize dot;

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
	//NSLog(@"profileChanged! %@",notification);
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
	[unitsTextField resignFirstResponder];
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
	{
		[unitsTextField becomeFirstResponder];
	}
	else if ([unitsTextField isEditing])
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
	NSString *s = [NSString stringWithString:@"<html><head></head><body style='background-color: transparent; color: black;'><p>&nbsp;&nbsp;&nbsp;&nbsp;</p><center><hr><h2>Welcome to Station Trader</h2><hr></center></body></html>"];
	
	[webView setOpaque: NO];
	[webView setBackgroundColor: [UIColor clearColor]];
	[webView setAlpha: 1.0f];
	[webView setScalesPageToFit: NO];
	[webView setDetectsPhoneNumbers: NO];
	[webView loadHTMLString:s baseURL: nil];
	

}

- (void)viewWillAppear:(BOOL)animated
{
	//NSLog(@"will appear!");
#ifdef CUSTOM_KEYBOARD
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(UIKeyboardWillHideNotification:) name:@"willHideKeyboard" object:nil];
#endif
	//[self showHideKeypadButton: NO];
	[self hideKeypad: self];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"profileChanged" object: nil];
#ifdef CUSTOM_KEYBOARD	
	// Register to Recieve notifications of the Decimal Key Being Pressed and when it is pressed do the corresponding addDecimal action.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDecimal:) name:@"DecimalPressed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
#endif
	
	//load salesTax and brokersFee to Labels
	//[self calculateBrokersFeeAndSalesTax];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self hideKeypad: self];

#ifdef CUSTOM_KEYBOARD	
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: @"willHideKeyboard" object:nil];	
	[[NSNotificationCenter defaultCenter] removeObserver: self name: @"DecimalPressed" object: nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
#endif
}


- (void) calculateBrokersFeeAndSalesTax
{
	NSString *activeProfileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];

	if (!activeProfileName)
		activeProfileName = @"Standard";
	
	int brokerRelations = 0.0f;
	int accounting = 0.0f;
	double corpStanding = 0.0f;
	double factionStanding = 0.0f;

	//NSLog(@"%@",profiles);
	
	for (NSMutableDictionary *profile in profiles)
	{
		if ([activeProfileName isEqualToString: [profile objectForKey:@"name"]])
		{
			//NSLog(@"%@",profile);
			
			brokerRelations = [[profile valueForKey:@"brokerRelations"] intValue];
			accounting = [[profile valueForKey:@"accounting"] intValue];
			corpStanding = [[profile valueForKey:@"corpStanding"] doubleValue];
			factionStanding = [[profile valueForKey:@"factionStanding"] doubleValue];
		}
	}
	
	//NSLog(@"%@",activeProfileName);
	
//	NSLog(@"%i,%i,%f,%f",brokerRelations,accounting,corpStanding,factionStanding);
	
	double totalSalesTax = 1.0 - ((double)accounting*0.1);
	
	double e = 2.71828183;
	double bfe_part1 = pow(e,(-0.1000 * factionStanding));
	double bfe_part2 = pow (e,(-0.0400 * corpStanding));

	double new_bfe = pow (e, (0.1 * factionStanding + 0.04 * corpStanding));
	

	//double brokers_fee_percentage = (1.000 - 0.05*(double)brokerRelations) * bfe_part1 * bfe_part2;
	
	double brokers_fee_percentage = (1.000 - 0.05*(double)brokerRelations) / new_bfe;

	
//	BrokerFee % = (1.000 % – 0.050 % × BrokerRelationsSkillLevel) / e ^ (0.1000 × FactionStanding + 0.04000 × CorporationStanding)
	
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

- (NSString *) beatifyNumber: (double) num
{
	NSLog(@"beatifyNumber: %f",num);
	NSString *temp = [NSString stringWithFormat:@"%.2f", num];
//	return temp;
	
//	NSMutableString *ret = [NSMutableString string];
	NSString *ret = @"";
	
	int decimalindex = [temp length]-3;
	
	BOOL decimalpassed = NO;
	
	for (int i = [temp length]; i > 0; i--)
	{
//		int index = ([temp length]-1) - i;
		int index = i-1;
		
		NSRange r;
		r.length = 1;
		r.location = index;
		
//		NSLog(@"location: %i/%i",r.location, r.length);
		
		NSString *c = [temp substringWithRange: r];
		if ([c containsString: @"."])
			decimalpassed = YES;
		
		
		ret = [c stringByAppendingString: ret];
		
		if ((decimalindex-index) > 0)
			if ((decimalindex-index) %3 == 0 && decimalpassed)
				ret = [@" " stringByAppendingString: ret];	
		

	}
	
	return ret;
}

- (IBAction)doCalc:(id)sender
{
   	//[sellPriceInput resignFirstResponder];
	//[buyPriceInput resignFirstResponder];
	
	[self hideKeypad: self];

//	float brokersFeeRate = [[NSUserDefaults standardUserDefaults] floatForKey:@"brokersFee"];
//	float salesTaxRate = [[NSUserDefaults standardUserDefaults] floatForKey:@"salesTax"];
	
	double brokersFeeRate = brokersFee;
	double salesTaxRate = salesTax;
	
	double buyPrice = [[buyPriceInput text] doubleValue];
	double sellPrice = [[sellPriceInput text] doubleValue];
	double units = [[unitsTextField text] doubleValue];
	if (units < 1.0)
		units = 1.0;
	
	double totalSalesTax = (salesTaxRate/100.0f) * sellPrice;
	
	double brokersFeeForBuy = (brokersFeeRate/100.0f) * buyPrice;
	double brokersFeeForSell = (brokersFeeRate/100.0f) * sellPrice;
	
	double totalBuyPrice = buyPrice + brokersFeeForBuy;
	double totalSellPrice = sellPrice - totalSalesTax - brokersFeeForSell;
	
	double winloss = totalSellPrice - totalBuyPrice;
	
	NSMutableString *s = [[[NSMutableString alloc] initWithString:	@"<html><head><title>Results</title></head><body style='background-color: transparent; color: black;'>"] autorelease];
	
	[s appendString:@"<table width=98%% rows=3 columns=2 border=0>"];
	[s appendString:@"<tr><td>Buy:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='crimson'>%@</font> ISK",[self beatifyNumber: (buyPrice * units)]]];
	[s appendString:@"</td></tr>"];
	[s appendString:@"<tr><td>Sell:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='green'>%@</font> ISK",[self beatifyNumber: (sellPrice * units)]]];
	[s appendString:@"</td></tr>"];
	
	[s appendString:@"<tr><td>Diff:</td><td align=right>"];	
	if (sellPrice-buyPrice > 0.0f)
		[s appendString:[NSString stringWithFormat:@"<font color='green'>%@</font> ISK",[self beatifyNumber: (sellPrice-buyPrice) * units]]];
	else
		[s appendString:[NSString stringWithFormat:@"<font color='crimson'>%@</font> ISK",[self beatifyNumber:(sellPrice-buyPrice)  * units]]];
	
	[s appendString:@"</td></tr>"];
	
	[s appendString:@"</table>"];
	
	[s appendString:@"<hr>"];
	
	[s appendString:@"<table width=98%% rows=3 columns=2 border=0>"];
	[s appendString:@"<tr><td>Broker's Fee:</td><td align=right>"];
	[s appendString:[NSString stringWithFormat:@"<font color='crimson'>%@</font> ISK",[self beatifyNumber:(brokersFeeForBuy+brokersFeeForSell) * units]]];
	[s appendString:@"<tr><td>Sales Tax:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='crimson'>%@</font> ISK",[self beatifyNumber:(totalSalesTax) * units]]];
	[s appendString:@"</td></tr>"];	 
	[s appendString:@"<tr><td>Total:</td><td align=right>"];	
	[s appendString:[NSString stringWithFormat:@"<font color='crimson'>%@</font> ISK",[self beatifyNumber:(totalSalesTax+brokersFeeForBuy+brokersFeeForSell) * units]]];
	[s appendString:@"</td></tr>"];	 
	[s appendString:@"</table>"];
	
	[s appendString:@"<hr>"];
	
	[s appendString:@"<table width=98%% rows=1 columns=2 border=0>"];
	[s appendString:@"<tr><td>Net win/loss:</td><td align=right>"];
	if (winloss > 0.0)
		[s appendString:[NSString stringWithFormat:@"<font color='green'>+%@</font> ISK",[self beatifyNumber:(winloss) * units]]];		
	else
		[s appendString:[NSString stringWithFormat:@"<font color='crimson'>%@</font> ISK",[self beatifyNumber:winloss * units]]];		
	[s appendString:@"</td></tr>"];	 
	[s appendString:@"</table>"];
	
	
	[s appendString:@"</body></html>"];
	
	[webView loadHTMLString:s baseURL: nil];
	
}


- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
	NSLog(@"should return lol!");
	
/*	if (aTextField == inputField)
	 {

	 [inputField resignFirstResponder];
	 }
*/	
	if (aTextField == buyPriceInput)
	{
		[sellPriceInput becomeFirstResponder];
		return NO;
	}
	
	if (aTextField == sellPriceInput)
	{
		//[calcButton becomeFirstResponder];
		//[aTextField resignFirstResponder];
		//[self hideKeypad: self];
		[unitsTextField becomeFirstResponder];

	//	return NO;
	}
	
	if (aTextField == unitsTextField)
	{
		[self doCalc: self];
	}
	
	return YES;
}
#ifdef CUSTOM_KEYBOARD
#pragma mark -
#pragma mark keyboard

void enumerateSubviews (id viewlol)
{
	static int enum_level = 0;

	enum_level ++;
	NSMutableString *tabstring = [NSMutableString stringWithCapacity: 8];
	for (int i = 0; i < enum_level; i++)
		[tabstring appendString:@"---"];

	NSLog(@"%@%@",tabstring, viewlol);
	NSLog(@"%@{",tabstring);
	
	for (int i = 0; i < [[viewlol subviews] count]; i++)
	{
		id temp = [[viewlol subviews] objectAtIndex: i];
		
		if ([[temp subviews] count] > 0)
			enumerateSubviews (temp);
		else
			NSLog(@"%@%@",tabstring,temp);
	}
	NSLog(@"%@}",tabstring);
	enum_level --;
}

// This function is called each time the keyboard is shown
- (void)keyboardWillShow:(NSNotification *)note {

	NSLog(@"keyboard will show ...");
	
	// Just used to reference windows of our application while we iterate though them
	UIWindow* tempWindow;
	
	// Because we cant get access to the UIKeyboard throught the SDK we will just use UIView. 
	// UIKeyboard is a subclass of UIView anyways
	UIView* keyboard;
	
	NSLog(@"penisse !");
	
	// Check each window in our application
	for(int c = 0; c < [[[UIApplication sharedApplication] windows] count]; c ++)
	{
		// Get a reference of the current window
		tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:c];
	//	NSLog(@"window: %@",tempWindow);
		enumerateSubviews(tempWindow);
		
		// Loop through all views in the current window
		for(int i = 0; i < [tempWindow.subviews count]; i++)
		{
			// Get a reference to the current view
			keyboard = [tempWindow.subviews objectAtIndex:i];
		//	NSLog(@"enum: %@ %i",keyboard, [tempWindow.subviews count]);
			
			// From all the apps i have made, they keyboard view description always starts with <UIKeyboard so I did the following
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
			{
				//NSLog(@"found keyboard: %@",[keyboard description]);
				
				// First test to see if the button has been created before.  If not, create the button.
				if (dot == nil) 
				{			
					dot = [UIButton buttonWithType:UIButtonTypeCustom];
				}
				
				// Position the button - I found these numbers align fine (0, 0 = top left of keyboard)
				dot.frame = CGRectMake(0, 163, 106, 53);
				
				// Add images to our button so that it looks just like a native UI Element.
				[dot setImage:[UIImage imageNamed:@"dotNormal.png"] forState:UIControlStateNormal];
				[dot setImage:[UIImage imageNamed:@"dotHighlighted.png"] forState:UIControlStateHighlighted];
				
				// Add the button to the keyboard
				[keyboard addSubview:dot];
				// Set the button to hidden. We will only unhide it when we need it.
				dot.hidden = YES;
				
				// When the decimal button is pressed, we send a message to ourself (the AppDelegate) which will then post a notification that will then append a decimal in the UITextField in the Appropriate View Controller.
				[dot addTarget:self action:@selector(sendDecimal:)  forControlEvents:UIControlEventTouchUpInside];
				
				return;
			}
		}
	}
}

- (void)sendDecimal:(id)sender 
{
	// Post a Notification that the Decimal Key was Pressed.
	[[NSNotificationCenter defaultCenter] postNotificationName:@"DecimalPressed" object:nil];	
}
#endif



- (void)textFieldDidBeginEditing:(UITextField *)textField 
{
	NSLog(@"textFieldDidBeginEditing");
	currentTextField = textField;
	
	
	if (textField != unitsTextField)
		[dot setHidden: NO];
	
/*	// We need to access the dot Button declared in the Delegate.
    ExampleAppDelegate *appDelegate = (ExampleAppDelegate *)[[UIApplication sharedApplication] delegate];
	// Only if we are editing within the Number Pad Text Field do we want the dot.
	if (numericTextField.editing) {
		// Show the Dot.
		appDelegate.dot.hidden = NO;
	} else {
		// Otherwise, Hide the Dot.
		appDelegate.dot.hidden = YES;
	}*/
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	currentTextField = nil;
	[dot setHidden: YES];
}
#ifdef CUSTOM_KEYBOARD
- (void)addDecimal:(NSNotification *)notification 
{
	NSLog(@"add decimal!");
	

	if (![[currentTextField text] containsString: @"."])
		[currentTextField setText: [[currentTextField text] stringByAppendingString: @"."]];
	
	// Apend the Decimal to the TextField.
//	numericTextField.text = [numericTextField.text stringByAppendingString:@"."];
}

#endif

@end
