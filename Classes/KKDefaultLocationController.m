    //
//  KKDefaultLocationController.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKDefaultLocationController.h"
#import "KKMapController.h"


@implementation KKDefaultLocationController

@synthesize locationListView;
@synthesize url;

-(id) initWithLocationURL:(NSString *) _url {
	self = [super init];
	if (self != nil) {
		self.url = _url;
		//theLocation = _theLocation;
	}
	return self;
}	
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

- (void)loadView {
	[super loadView];
	//self.title = @"足迹";
	locationListView = [[KKLocationListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	locationListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[locationListView setURL:self.url];
	locationListView.locationListDelegate = self;
	//NSLog(@"the url:%@", url);
	[self.view addSubview:locationListView];
	[locationListView refresh];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	[locationListView release];
	[url release];
    [super dealloc];
}

-(void) locationList:(KKLocationListView*) locationList didTouchAt:(NSIndexPath *) indexPath {
	NSDictionary* locationInfo = [locationList getMsgDataAt:indexPath];
	CLLocationCoordinate2D coord;
	coord.latitude = [[locationInfo objectForKey:@"lat"] doubleValue];
	coord.longitude = [[locationInfo objectForKey:@"lng"] doubleValue];
	KKMapController* controller = [[KKMapController alloc] initWithLocation2D:coord];
	/*
	controller.editable = YES;
	controller.isUnFollow = YES;
	controller.description = [locationInfo objectForKey:@"description"];
	controller.followId = [locationInfo objectForKey:@"id"];
	controller.delegate = self;
	 */
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}



@end
