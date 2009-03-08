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
#import "ProfilesController.h"

@implementation EveTraderAppDelegate

@synthesize window;
@synthesize tabBarController;

+ (void) initialize
{
	NSMutableArray *profiles = [NSMutableArray array];
	
	NSMutableDictionary *standardProfile = [NSMutableDictionary dictionary];
	[standardProfile setValue:@"Standard" forKey: @"name"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"brokerRelations"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"accounting"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"corpStanding"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"factionStanding"];
	[profiles addObject: standardProfile];

	standardProfile = [NSMutableDictionary dictionary];
	[standardProfile setValue:@"Jita" forKey: @"name"];
	[standardProfile setValue:[NSNumber numberWithFloat: 5.0f] forKey: @"brokerRelations"];
	[standardProfile setValue:[NSNumber numberWithFloat: 5.0f] forKey: @"accounting"];
	[standardProfile setValue:[NSNumber numberWithFloat: 10.0f] forKey: @"corpStanding"];
	[standardProfile setValue:[NSNumber numberWithFloat: 10.0f] forKey: @"factionStanding"];
	[profiles addObject: standardProfile];
	
	NSLog(@"%@",profiles);
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: 
								 profiles, @"profiles",
								 @"Standard", @"activeProfile",
								 
								//deprecated
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
/*	SetupController *svc = [[SetupController alloc] initWithNibName:@"SetupView" bundle: nil];
	dummyArray = [NSArray arrayWithObject: svc];
	
	[setupNavigationController setViewControllers: dummyArray];
	[setupNavigationController setTitle:@"Setup"];
	[[setupNavigationController navigationBar] setBarStyle: UIBarStyleBlackOpaque];
	[setupNavigationController setNavigationBarHidden: YES];*/

	ProfilesController *pvc = [[ProfilesController alloc] initWithNibName:@"ProfileView" bundle: nil];
	dummyArray = [NSArray arrayWithObject: pvc];
	
	[profilesNavigationController setViewControllers: dummyArray];
	[profilesNavigationController setTitle:@"Profiles"];
	[[profilesNavigationController navigationBar] setBarStyle: UIBarStyleBlackOpaque];
	[profilesNavigationController setNavigationBarHidden: NO];
	
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

