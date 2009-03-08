#import "SetupController.h"

@implementation SetupController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName: nibName bundle: nibBundle];
	[self setTitle:@"Setup"];

	return self;
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


- (void)viewWillAppear:(BOOL)animated
{
	//NSLog(@"will appear!");
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(UIKeyboardWillHideNotification:) name:@"willHideKeyboard" object:nil];
	
	//[self showHideKeypadButton: NO];
	[self hideKeypad: self];
	
	float brokerRelations = [[NSUserDefaults standardUserDefaults] floatForKey:@"brokerRelations"];
	float accounting = [[NSUserDefaults standardUserDefaults] floatForKey:@"accounting"];
	float corpStanding = [[NSUserDefaults standardUserDefaults] floatForKey:@"corpStanding"];
	float factionStanding = [[NSUserDefaults standardUserDefaults] floatForKey:@"factionStanding"];
	
	NSString *newCaption = [NSString stringWithFormat: @"%.0f", brokerRelations];
	[brokerRelationsInput setText: newCaption];
	
	newCaption = [NSString stringWithFormat: @"%.0f", accounting];
	[accountingInput setText: newCaption];
	
	newCaption = [NSString stringWithFormat: @"%.0f", corpStanding];
	[corpStandingInput setText: newCaption];
	
	newCaption = [NSString stringWithFormat: @"%.0f", factionStanding];
	[factionStandingInput setText: newCaption];
	
}

- (void)viewWillDisappear:(BOOL)animated
{
//	NSLog(@"will disappear!");
	[self hideKeypad: self];
	
	[[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver: self name:@"willHideKeyboard" object:nil];	
}

- (IBAction) saveChanges: (id)sender 
{
	[self hideKeypad: self];
	
    float brokerRelations = [[brokerRelationsInput text] floatValue];
	float accounting = [[accountingInput text] floatValue];
	float corpStanding = [[corpStandingInput text] floatValue];
	float factionStanding = [[factionStandingInput text] floatValue];
	
	float totalSalesTax = 1.0 - (accounting*0.1);
	
	float e = 2.71828183;
	float bfe_part1 = pow(e,(-0.1000 * factionStanding));
	float bfe_part2 = pow (e,(-0.0400 * corpStanding));
	
	float brokers_fee_percentage = (1.000 - 0.05*brokerRelations) * bfe_part1 * bfe_part2;

	[[NSUserDefaults standardUserDefaults] setFloat: brokerRelations forKey:@"brokerRelations"];
	[[NSUserDefaults standardUserDefaults] setFloat: accounting forKey:@"accounting"];
	[[NSUserDefaults standardUserDefaults] setFloat: corpStanding forKey:@"corpStanding"];
	[[NSUserDefaults standardUserDefaults] setFloat: factionStanding forKey:@"factionStanding"];

	[[NSUserDefaults standardUserDefaults] setFloat: brokers_fee_percentage forKey:@"brokersFee"];
	[[NSUserDefaults standardUserDefaults] setFloat: totalSalesTax forKey:@"salesTax"];
	[[NSUserDefaults standardUserDefaults] synchronize]; 
	
	[[self tabBarController] setSelectedIndex: 0];
}

- (IBAction) hideKeypad: (id) sender
{
	[brokerRelationsInput resignFirstResponder];
	[accountingInput resignFirstResponder];
	[corpStandingInput resignFirstResponder];
	[factionStandingInput resignFirstResponder];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"willHideKeyboard" object: nil];
	
	
}

- (void) selectNextTextfield: (id) sender
{
	if ([brokerRelationsInput isEditing])
	{	
		[accountingInput becomeFirstResponder];
		return;
	}
	if ([accountingInput isEditing])
	{	
		[factionStandingInput becomeFirstResponder];
		return;		
	}
	if ([factionStandingInput isEditing])
	{	
		[corpStandingInput becomeFirstResponder];
		return;		
	}
	if ([corpStandingInput isEditing])
	{	
		[self saveChanges: self];
		return;
	}

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



- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
	/* if (aTextField == inputField)
	 {
	 // The return key is set to Done, so hide the keyboard
	 [inputField resignFirstResponder];
	 }*/
	/*NSLog(@"shoul i return?");
	
	if (aTextField == brokerRelationsInput)
	{
		[accountingInput becomeFirstResponder];
		return NO;
	}
	if (aTextField == accountingInput)
	{
		[factionStandingInput becomeFirstResponder];
		return NO;
	}
	if (aTextField == factionStandingInput)
	{
		[corpStandingInput becomeFirstResponder];
		return NO;
	}
	if (aTextField == corpStandingInput)
	{
		[aTextField resignFirstResponder];
		return NO;
	}*/
	
	
	return YES;
}


@end
