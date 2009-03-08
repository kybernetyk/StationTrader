//
//  EveTraderAppDelegate.m
//  EveTrader
//
//  Created by jrk on 01.03.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "EveTraderAppDelegate.h"
#import "AboutController.h"
#import "CalculatorController.h"
#import "SetupController.h"

@implementation EveTraderAppDelegate

@synthesize window;
@synthesize tabBarController;

+ (void) initialize
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: 
								 @"0.0",@"brokerRelations",
								 @"0.0",@"accounting",
								 @"0.0", @"corpStanding", 
								 @"0.0", @"factionStanding", 
							
								 @"1.0", @"brokersFee",
								 @"1.0", @"salesTax",
								 nil]; 
	[userDefaults registerDefaults:appDefaults];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
	//[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
	
/*	IBOutlet UINavigationController *calcNavigationController;
	IBOutlet UINavigationController *setupNavigationController;*/

	/*
	 *	Calc View Controller setup
	 */
	CalculatorController *cvc = [[CalculatorController alloc] initWithNibName:@"CalculatorView" bundle: nil];
	NSArray *dummyArray = [NSArray arrayWithObject: cvc];
	
	[calcNavigationController setViewControllers: dummyArray];
	[calcNavigationController setTitle: @"Calculator"];
	[[calcNavigationController navigationBar] setBarStyle: UIBarStyleBlackOpaque];
	[calcNavigationController setNavigationBarHidden: YES];
	
	/*
	 *	Setup View Controller setup
	 */
	SetupController *svc = [[SetupController alloc] initWithNibName:@"SetupView" bundle: nil];
	dummyArray = [NSArray arrayWithObject: svc];
	
	[setupNavigationController setViewControllers: dummyArray];
	[setupNavigationController setTitle:@"Setup"];
	[[setupNavigationController navigationBar] setBarStyle: UIBarStyleBlackOpaque];
	[setupNavigationController setNavigationBarHidden: YES];
	
	/*
	 *	About View Controller setup
	 */
	AboutController *abc = [[AboutController alloc] initWithNibName:@"AboutView" bundle: nil];
	dummyArray = [NSArray arrayWithObject: abc];
	
	[aboutNavigationController setViewControllers: dummyArray];
	[aboutNavigationController setTitle: @"About"];
	[[aboutNavigationController navigationBar] setBarStyle: UIBarStyleBlackOpaque];
	[aboutNavigationController setNavigationBarHidden: YES];
	
	
	// Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

