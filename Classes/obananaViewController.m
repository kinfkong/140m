//
//  obananaViewController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "obananaViewController.h"

#import "KKLoginController.h"
#import "UserModel.h"
#import "MainTabController.h"
#import "ComposeMsgController.h"

@implementation obananaViewController

@synthesize controller;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void) viewReload {
	if ([[UserModel getInstance] hasLogin]) {
		// use the MainTabControlelr
		self.controller = [[MainTabController alloc] init];
		
	} else {
		// use the loginController
		self.controller = [[KKLoginController alloc] init];
		((KKLoginController *)self.controller).offsetHeight = 50;
		// controller = [[ComposeMsgController alloc] init];
	}
	
	self.view = self.controller.view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[UserModel getInstance].controller = self;
	[self viewReload];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[controller release];
    [super dealloc];
}

@end
