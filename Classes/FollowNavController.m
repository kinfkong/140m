    //
//  FollowNavController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "FollowNavController.h"
#import "KKUserListView.h"
#import "KKUserInfoController.h"
#import "KKSearchController.h"
#import "UserModel.h"
#import "KKMapController.h"
#import "KKLocationAdjustController.h"


@implementation FollowNavController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
 [super viewDidLoad];
	self.title = @"收听";
	userListViewRefreshed = NO;
	locationListViewRefreshed = NO;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	NSArray *itemArray = [NSArray arrayWithObjects:@"用户", @"地点", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 180, 30);
	self.navigationItem.titleView = segmentedControl;
	
	segmentedControl.selectedSegmentIndex = 1;
	[segmentedControl addTarget:self action:@selector(pickSegmentControl:) forControlEvents:UIControlEventValueChanged];
	
	userListView = [[KKUserListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	userListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[userListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/user/%@/", [[UserModel getInstance] getUserName]]];
	userListView.userListdelegate = self;
	[self.view addSubview:userListView];
	
	locationListView = [[KKLocationListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	locationListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	locationListView.locationListDelegate = self;
	// [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/location/%@/", [[UserModel getInstance] getUserName]]
	[locationListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/location/%@/", [[UserModel getInstance] getUserName]]];
	[self.view addSubview:locationListView];
	segmentedControl.selectedSegmentIndex = 0;
	
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFollow:)];
	self.navigationItem.leftBarButtonItem = item;
	[item release];
	
	UIBarButtonItem *freshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFollow:)];
	self.navigationItem.rightBarButtonItem = freshItem;
	[freshItem release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[userListView release];
	[locationListView release];
	[segmentedControl release];
    [super dealloc];
}


-(void) pickSegmentControl:(id) sender {
	if (segmentedControl.selectedSegmentIndex == 0) {
		locationListView.hidden = YES;
		if (!userListViewRefreshed) {
			[userListView refresh];
			userListViewRefreshed = YES;
		}
		userListView.hidden = NO;
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		locationListView.hidden = NO;
		userListView.hidden = YES;
		if (!locationListViewRefreshed) {
		[locationListView refresh];
			locationListViewRefreshed = YES;
		}
	}
}

-(void) userList:(KKUserListView*) userList didTouchAt:(NSIndexPath *) indexPath; {
	NSDictionary* data = [userList getMsgDataAt:(NSIndexPath *) indexPath];
	//NSLog(@"The data:%@", data);
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:data];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) addFollow:(id) sender {
	if (segmentedControl.selectedSegmentIndex == 0) {
		KKSearchController* controller = [[KKSearchController alloc] init];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	} else {
		KKLocationAdjustController* controller = [[KKLocationAdjustController alloc] initWithAddLocationStyle];
		controller.delegate = self;
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

-(void) refreshFollow:(id) sender {
	if (segmentedControl.selectedSegmentIndex == 0) {
		[userListView cleanAll];
		[userListView refresh];
	} else {
		[locationListView cleanAll];
		[locationListView refresh];
	}
}


-(void) onaddfollow:(CLLocation *)location {
	[locationListView refresh];
}

-(void) locationList:(KKLocationListView*) locationList didTouchAt:(NSIndexPath *) indexPath {
	NSDictionary* locationInfo = [locationList getMsgDataAt:indexPath];
	CLLocationCoordinate2D coord;
	coord.latitude = [[locationInfo objectForKey:@"lat"] doubleValue];
	coord.longitude = [[locationInfo objectForKey:@"lng"] doubleValue];
	KKMapController* controller = [[KKMapController alloc] initWithLocation2D:coord];
	controller.editable = YES;
	controller.isUnFollow = YES;
	controller.description = [locationInfo objectForKey:@"description"];
	controller.followId = [locationInfo objectForKey:@"id"];
	controller.delegate = self;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) map:(KKMapController *) mapController onFinishedModification:(NSString*) info {
	[locationListView cleanAll];
	[locationListView refresh];
}

@end
