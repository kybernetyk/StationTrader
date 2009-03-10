#import "SetupController.h"

@implementation SetupController
@synthesize profileToEdit;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName: nibName bundle: nibBundle];
//	[self setTitle:@"Setup"];

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
	//[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(UIKeyboardWillHideNotification:) name:@"willHideKeyboard" object:nil];
	
	//[self showHideKeypadButton: NO];
	[self hideKeypad: self];

	
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	
	int brokerRelations = 0;
	int accounting = 0;
	float corpStanding = 0.0f;
	float factionStanding = 0.0f;
	
	
	for (NSMutableDictionary *profile in profiles)
	{
		if ([profileToEdit isEqualToString: [profile objectForKey:@"name"]])
		{
			//NSLog(@"%@",profile);
			
			brokerRelations = [[profile valueForKey:@"brokerRelations"] intValue];
			accounting = [[profile valueForKey:@"accounting"] intValue];
			corpStanding = [[profile valueForKey:@"corpStanding"] floatValue];
			factionStanding = [[profile valueForKey:@"factionStanding"] floatValue];
		}
	}
	
	
	NSString *newCaption = [NSString stringWithFormat: @"%i", brokerRelations];
	[brokerRelationsInput setText: newCaption];
	
	newCaption = [NSString stringWithFormat: @"%i", accounting];
	[accountingInput setText: newCaption];
	
	newCaption = [NSString stringWithFormat: @"%.2f", corpStanding];
	[corpStandingInput setText: newCaption];
	
	newCaption = [NSString stringWithFormat: @"%.2f", factionStanding];
	[factionStandingInput setText: newCaption];
	
	[profileNameInput setText: profileToEdit];
	
	
	
}

- (void)viewWillDisappear:(BOOL)animated
{
//	NSLog(@"will disappear!");
	[self hideKeypad: self];
	
	//[[NSNotificationCenter defaultCenter] removeObserver: self name:UIKeyboardWillShowNotification object:nil];
	//[[NSNotificationCenter defaultCenter] removeObserver: self name:@"willHideKeyboard" object:nil];	
}

- (IBAction) saveChanges: (id)sender 
{
	[self hideKeypad: self];
	
    int brokerRelations = [[brokerRelationsInput text] intValue];
	int accounting = [[accountingInput text] intValue];
	float corpStanding = [[corpStandingInput text] floatValue];
	float factionStanding = [[factionStandingInput text] floatValue];
	NSString *profileName = [profileNameInput text];
	
	if (brokerRelations < 0)
		brokerRelations = 0;
	if (brokerRelations > 5)
		brokerRelations = 5;
	
	if (accounting < 0)
		accounting = 0;
	if (accounting > 5)
		accounting = 5;
	
	
	if (corpStanding < -10.0f)
		corpStanding = -10.0f;
	if (corpStanding > 10.0f)
		corpStanding = 10.0f;
	
	if (factionStanding < -10.0f)
		factionStanding = -10.0f;
	if (factionStanding > 10.0f)
		factionStanding = 10.0f;
	
//	float totalSalesTax = 1.0 - (accounting*0.1);
	
//	float e = 2.71828183;
//	float bfe_part1 = pow(e,(-0.1000 * factionStanding));
//	float bfe_part2 = pow (e,(-0.0400 * corpStanding));
	
//	float brokers_fee_percentage = (1.000 - 0.05*brokerRelations) * bfe_part1 * bfe_part2;
/*
	[[NSUserDefaults standardUserDefaults] setFloat: brokerRelations forKey:@"brokerRelations"];
	[[NSUserDefaults standardUserDefaults] setFloat: accounting forKey:@"accounting"];
	[[NSUserDefaults standardUserDefaults] setFloat: corpStanding forKey:@"corpStanding"];
	[[NSUserDefaults standardUserDefaults] setFloat: factionStanding forKey:@"factionStanding"];

	[[NSUserDefaults standardUserDefaults] setFloat: brokers_fee_percentage forKey:@"brokersFee"];
	[[NSUserDefaults standardUserDefaults] setFloat: totalSalesTax forKey:@"salesTax"];
	[[NSUserDefaults standardUserDefaults] synchronize]; 
	
	[[self tabBarController] setSelectedIndex: 0];*/

	
	NSMutableArray *profiles = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"]];
	//NSLog(@"profiles: %@",profiles);

	int index = 0;
	
	for (NSDictionary *profile in profiles)
	{
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: [profiles objectAtIndex: index]];
		NSString *str = [dict objectForKey:@"name"];
		
		if ([str isEqualToString: [self profileToEdit]])
		{
			NSMutableDictionary *theProfile = [NSMutableDictionary dictionary];
			[theProfile setValue: profileName forKey: @"name"];
			[theProfile setValue:[NSNumber numberWithInt: index] forKey:@"id"];
			[theProfile setValue:[NSNumber numberWithInt: brokerRelations] forKey: @"brokerRelations"];
			[theProfile setValue:[NSNumber numberWithInt: accounting] forKey: @"accounting"];
			[theProfile setValue:[NSNumber numberWithFloat: corpStanding] forKey: @"corpStanding"];
			[theProfile setValue:[NSNumber numberWithFloat: factionStanding] forKey: @"factionStanding"];
			[profiles replaceObjectAtIndex: index withObject: [NSDictionary dictionaryWithDictionary:theProfile]];
			break;
		}
		
		index++;
	}


	//NSLog(@"profiles: %@",profiles);

	NSString *activeProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray: profiles] forKey:@"profiles"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	if ([activeProfile isEqualToString: [self profileToEdit]])
	{
		[[NSUserDefaults standardUserDefaults] setObject:profileName forKey:@"activeProfile"];		
		[[NSUserDefaults standardUserDefaults] synchronize];

		[[NSNotificationCenter defaultCenter] postNotificationName:@"profileChanged" object: nil];
	}
	

	[[self navigationController] popViewControllerAnimated: YES];
}

- (IBAction) hideKeypad: (id) sender
{
	[profileNameInput resignFirstResponder];
	[brokerRelationsInput resignFirstResponder];
	[accountingInput resignFirstResponder];
	[corpStandingInput resignFirstResponder];
	[factionStandingInput resignFirstResponder];

	[[NSNotificationCenter defaultCenter] postNotificationName:@"willHideKeyboard" object: nil];
	
	
}

- (void) profileNameValueChanged: (id) sender
{
	//NSLog(@"omfg %@",[profileNameInput text]);
	//[self setProfileToEdit: [profileNameInput text]];
	[self setTitle: [profileNameInput text]];
}

- (void) selectNextTextfield: (id) sender
{
	if ([profileNameInput isEditing])
	{
		[brokerRelationsInput becomeFirstResponder];
		return;
	}
	
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

	//if (aTextField == profileNameInput)
	[self hideKeypad: self];

	return NO;
	
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
