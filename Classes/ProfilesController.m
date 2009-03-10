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


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[[self navigationItem] setRightBarButtonItem:[self editButtonItem] animated: NO];
}


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

#define ADD_CELL_INDEX 1
#define EDIT_CELL_INDEX 0

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle
{
	self = [super initWithNibName: nibName bundle: nibBundle];
	[self setTitle:@"Profiles"];
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[theTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing: editing animated: animated];

	
	if (editing)
	{
		[theTableView setEditing: YES animated: YES];
	}
	else
	{		
		[theTableView setEditing: NO animated: YES];
	}
}


- (void) addNewProfile
{

	NSMutableArray *profiles = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"]];
	
	NSString *newName = @"New Profile";
	BOOL stopCheck = NO;
	int profileNumber = 2;
	
	do
	{
		stopCheck = YES;
		for (NSDictionary *profile in profiles)
		{
			NSString *profilename = [profile objectForKey: @"name"];
			
			if ([profilename isEqualToString: newName])
			{
				newName = [NSString stringWithFormat:@"New Profile %i", profileNumber++];
				stopCheck = NO;
			}
		}
		
	} while (stopCheck == NO);
	
	NSMutableDictionary *standardProfile = [NSMutableDictionary dictionary];
	[standardProfile setValue: newName forKey: @"name"];
	[standardProfile setValue:[NSNumber numberWithInt: [profiles count] + 1] forKey:@"id"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"brokerRelations"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"accounting"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"corpStanding"];
	[standardProfile setValue:[NSNumber numberWithFloat: 0.0f] forKey: @"factionStanding"];
	[profiles addObject: standardProfile];
	
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray: profiles] forKey:@"profiles"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[self editProfileAtIndex: [profiles count]-1];
	
}

- (void) editProfileAtIndex: (int) index
{
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	NSMutableDictionary *dict = [profiles objectAtIndex: index];
	NSString *str = [dict objectForKey:@"name"];
	
    SetupController *svc = [[SetupController alloc] initWithNibName:@"SetupView" bundle: nil];
	[svc setTitle: str];
	[svc setProfileToEdit: str];
	
	[[self navigationController] pushViewController: svc animated: YES];
	[svc release];
	
}

- (void) removeProfileAtIndex: (int) index
{
	NSMutableArray *profiles = [NSMutableArray arrayWithArray: [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"]];
	NSMutableDictionary *dict = [profiles objectAtIndex: index];
	[profiles removeObject: dict];
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray: profiles] forKey:@"profiles"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (NSString *) nameForProfileAtIndex: (int) index
{
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	if ([profiles count] <= 0)
		return nil;
	
	NSMutableDictionary *dict = [profiles objectAtIndex: index];
	NSString *str = [dict objectForKey:@"name"];

	return str;
}

- (void) setActiveProfile: (NSString *) name
{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:@"activeProfile"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"profileChanged" object: nil];

}

- (NSString *) activeProfile
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	
	//if ([self isEditing])
	//	return [profiles count];
	
	return [profiles count]+2;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if ([tableView isEditing])
		return;
	
	[self editProfileAtIndex: [indexPath row]];
	
	
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

		cell = [cells objectAtIndex: 0];
    }
	

    

	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];


	if ([indexPath row] == [profiles count]+EDIT_CELL_INDEX)
	{
		[cell setText: @"Edit Profile List ..."];
		[cell setAccessoryType: UITableViewCellAccessoryNone];
		return cell;
	}
	
	if ([indexPath row] == [profiles count]+ADD_CELL_INDEX)
	{
		[cell setText: @"Add new Profile ..."];
		[cell setAccessoryType: UITableViewCellAccessoryNone];
		return cell;
	}
	
	[cell setAccessoryType: UITableViewCellAccessoryDetailDisclosureButton];

	NSMutableDictionary *dict = [profiles objectAtIndex: [indexPath row]];
	NSString *str = [dict objectForKey:@"name"];
	
	NSString *activeProfile = [[NSUserDefaults standardUserDefaults] objectForKey:@"activeProfile"];
	
	if ([str isEqualToString: activeProfile])
	{	
		[cell setText: [NSString stringWithFormat:@"√ %@",str]];
	}
	else
	{
		[cell setText: str];
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];

	if ([indexPath row] == [profiles count]+ADD_CELL_INDEX)
	{
		[self addNewProfile];
		//[tableView setEditing: YES animated: YES];
		NSIndexPath *ip = [NSIndexPath indexPathForRow:[indexPath row]-ADD_CELL_INDEX inSection:[indexPath section]];
		NSArray *arr = [NSArray arrayWithObject: ip];
		[tableView insertRowsAtIndexPaths: arr withRowAnimation: UITableViewRowAnimationLeft];
		[tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[indexPath row]+ADD_CELL_INDEX inSection:[indexPath section]] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
		[tableView reloadData];
		
		return;
	}
	
	if ([indexPath row] == [profiles count]+EDIT_CELL_INDEX)
	{
		[self setEditing: YES animated: YES];
		return;
	}
	

	NSMutableDictionary *dict = [profiles objectAtIndex: [indexPath row]];
	NSString *str = [dict objectForKey:@"name"];
	
	[self setActiveProfile: str];
	
	[tableView reloadData];
	

	

	
	// Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
 	NSMutableArray *profiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"profiles"];
	
	if ([indexPath row] >= [profiles count])
	{
		return NO;
	}
	
	return YES;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        // Delete the row from the data source
        
		NSString *profileToRemove = [self nameForProfileAtIndex: [indexPath row]];
		
		[self removeProfileAtIndex: [indexPath row]];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];

		if ([profileToRemove isEqualToString: [self activeProfile]])
		{
			[self setActiveProfile: [self nameForProfileAtIndex: 0]];
		}
		
		[tableView reloadData];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



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

