//
//  CustomDiffTableViewController.m
//  OTG-Intervals
//
//  Created by Logan Moseley on 11/22/10.
//  Copyright 2010 CalamitySoft. All rights reserved.
//

#import "CustomDiffTableViewController.h"
#import "MainViewController.h"
#import "Settings.h"
#import "LoadFromFile.h"


@implementation CustomDiffTableViewController


#pragma mark -
#pragma mark View lifecycle

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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// Return the number of rows in the section.
    return [self.dataSourceArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	
	// Set the text
	cell.textLabel.text = [self.dataSourceArray objectAtIndex:indexPath.row];

	// Make it not highlight
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
	// Setup the UISwitch-eroo	
	UIControl *control = [self.switches objectAtIndex:indexPath.row];
	[control addTarget:self action:@selector(flipSwitch:) forControlEvents:UIControlEventValueChanged];
	[cell.contentView addSubview:control];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(void)flipSwitch:(id)sender {
	[[Settings sharedSettings] setCurrentDifficulty:kCustomDifficulty];
	
	// If changing that value would leave zero
	//    custom difficulty chords enabled
	if (![[Settings sharedSettings] setCustomDifficultyAtIndex:[self.switches indexOfObject:sender] 
													   toValue:[sender isOn]] ) {		
		UIAlertView *alert = [[UIAlertView alloc]
							  initWithTitle: nil
							  message: @"The Custom difficulty must have at least one interval enabled."
							  delegate: nil
							  cancelButtonTitle:@"OK"
							  otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		[sender setOn:YES animated:YES];
	}
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Lazy creation of controls

- (NSArray *)dataSourceArray {
    if (dataSourceArray == nil) {

		// Initialize dataSourceArray (intervals names) from file
		NSError *loadError;
		dataSourceArray = (NSArray*) [LoadFromFile newObjectForKey:@"IntervalNames" error:&loadError];
		if (!dataSourceArray) {
			NSLog(@"(CustomDiffTableVC) Error in loading interval names: %@", [loadError domain]);
		}
    }
    return dataSourceArray;
}

- (NSArray*)switches {
	if (switches == nil) {
		
		NSMutableArray *tempSwitches = [[NSMutableArray alloc] initWithObjects:nil];
		NSArray *tempCustomDiff = [[Settings sharedSettings] customDifficulty];
		
		for (uint i=0; i<[self.dataSourceArray count]; i++) {
			CGRect frame = CGRectMake(198.0, 8.0, 94.0, 27.0);
			UISwitch *tempSwitch = [[UISwitch alloc] initWithFrame:frame];	// UISwitch actually ignores the CGRect size parameters
			
			if ([[tempCustomDiff objectAtIndex:i] boolValue]) {
				[tempSwitch setOn:YES];
			} else {
				[tempSwitch setOn:NO];
			}
			
			[tempSwitches addObject:tempSwitch];
			[tempSwitch release];
		}
		
		switches = [[NSArray alloc] initWithArray:tempSwitches];
		[tempSwitches release];
	}
	return switches;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[dataSourceArray release];
	[switches release];
	
    [super dealloc];
}


@end
