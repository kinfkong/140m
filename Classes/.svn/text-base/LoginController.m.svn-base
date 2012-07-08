//
//  LoginController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"


@implementation LoginController


@synthesize accountCell;
@synthesize passwordCell;
@synthesize tableView;
@synthesize accountTextField;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.backgroundColor = [UIColor clearColor];
	//[self.accountTextField becomeFirstResponder];
	[accountTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];

}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	//[self.accountTextField becomeFirstResponder];
	[accountTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
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

-(IBAction) registerAccount:(id) sender {
	RegisterController* registerController = [[RegisterController alloc] init];
	[self presentModalViewController:registerController animated:YES];
	[registerController release];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if([indexPath row] == 0) return self.accountCell;
	if([indexPath row] == 1) return self.passwordCell;
	
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (void)dealloc {
    [super dealloc];
}


@end
