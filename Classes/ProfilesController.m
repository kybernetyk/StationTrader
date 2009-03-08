//
//  ProfilesController.m
//  EveTrader
//
//  Created by jrk on 08.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "ProfilesController.h"
#import "SetupController.h"
#import "CustomTableViewCell.h"

@implementation ProfilesController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName: nibName bundle: nibBundle];
	[self setTitle:@"Profiles"];
	
	return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void)viewWillAppear:(BOOL)animated
{
/*	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
    NSString *activeProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
	
	
	for (NSMutableDictionary *profile in profiles)
	{
		if ([activeProfile isEqualToString: [profile objectForKey:@"name"]])
		{
			NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];

			[theTableView selectRowAtIndexPath: ip animated: NO scrollPosition: UITableViewScrollPositionMiddle];
		}
	}
*/
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	return [profiles count];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	NSMutableDictionary *dict = [profiles objectAtIndex: [indexPath row]];
	NSString *str = [dict objectForKey:@"name"];
	
    SetupController *svc = [[SetupController alloc] initWithNibName:@"SetupView" bundle: nil];
	[svc setTitle: str];
	
	
	/* dummyArray = [NSArray arrayWithObject: svc];
	 
	 [setupNavigationController setViewControllers: dummyArray];
	 [setupNavigationController setTitle:@"Setup"];
	 [[setupNavigationController navigationBar] setBarStyle: UIBarStyleBlackOpaque];
	 [setupNavigationController setNavigationBarHidden: YES];*/
	
	[[self navigationController] pushViewController: svc animated: YES];
	//[[self parentViewController] pushViewController: svc];
	
	NSLog(@"%@",	[self navigationController]);
	
	[svc release];
	
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    static NSString *CellIdentifier = @"ACell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
		NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options: nil];
		NSLog(@"%@",cells);
		cell = [cells objectAtIndex: 0];
    }
	
	NSLog(@"ip: %@",indexPath);
    
	[cell setAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];
	//[cell setAccessoryAction:@selector(editProfile:)];

	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	NSMutableDictionary *dict = [profiles objectAtIndex: [indexPath row]];
	NSString *str = [dict objectForKey:@"name"];
	
	NSString *activeProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];

	
	if ([str isEqualToString: activeProfile])
	{	
//		[cell setTextColor: [UIColor greenColor]];
		[cell setText: [NSString stringWithFormat:@"√ %@",str]];
	}
	else
	{
//		[cell setTextColor: [UIColor darkTextColor]];
		[cell setText: str];
	}
	
	// Set up the cell...

	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	NSMutableDictionary *dict = [profiles objectAtIndex: [indexPath row]];
	NSString *str = [dict objectForKey:@"name"];
	
	[[NSUserDefaults standardUserDefaults] setObject:str forKey:@"activeProfile"];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"profileChanged" object: nil];
	[tableView reloadData];
	

	

	
	// Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

