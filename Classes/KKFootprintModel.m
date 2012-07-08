    //
//  KKFootprintModel.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-19.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKFootprintModel.h"
#import "UtilModel.h"
#import "UserModel.h"

@implementation KKFootprintModel


static KKFootprintModel* instance = nil;


+(KKFootprintModel *) getInstance {
	if (instance == nil) {
		instance = [[KKFootprintModel alloc] init];
	}
	return instance;
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
    [super dealloc];
}

-(void) sendFootprintWithNetwork:(CLLocation *) location {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[location retain];
	NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
	[data setObject:location forKey:@"location"];
	[data setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
	[[UtilModel getInstance] postData:data toURL:@"http://m.obanana.com/index.php/footprint/up"];
	[data release];
	[location release];
	[pool release];
}

-(void) sendFootprint:(CLLocation*) location {
	[NSThread detachNewThreadSelector:@selector(sendFootprintWithNetwork:) toTarget:self withObject:location];
	
}

@end
