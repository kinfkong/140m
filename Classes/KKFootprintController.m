    //
//  KKFootprintController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-19.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKFootprintController.h"
#import "KKLocationListView.h"
#import "UserModel.h"


@implementation KKFootprintController

@synthesize userName;
-(id) initWithUserName:(NSString *) _userName {
	self = [super init];
	if (self != nil) {
		self.userName = _userName;
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.title = @"足迹";
	KKLocationListView* locationListView = [[KKLocationListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	locationListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/footprint/%@/", self.userName];
	[locationListView setURL:url];
	//NSLog(@"the url:%@", url);
	[self.view addSubview:locationListView];
	 [locationListView refresh];
	[locationListView release];
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
	[userName release];
    [super dealloc];
}


@end
