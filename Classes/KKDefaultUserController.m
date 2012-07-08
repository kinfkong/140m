    //
//  KKDefaultUserController.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKDefaultUserController.h"
#import "KKUserInfoController.h"


@implementation KKDefaultUserController
@synthesize userListView;
@synthesize url;
-(id) initWithUserURL:(NSString*) _url {
	self = [super init];
	if (self != nil) {
		self.url = _url;
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
	userListView = [[KKUserListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	userListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[userListView setURL:self.url];
	userListView.userListdelegate = self;
	[self.view addSubview:userListView];
	[userListView refresh];
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
	[userListView release];
	[url release];
    [super dealloc];
}

-(void) userList:(KKUserListView*) userList didTouchAt:(NSIndexPath *) indexPath {
	//KKUserListView* userListView = (KKUserListView*) [self.view viewWithTag:100];
	NSDictionary* data = [userList getMsgDataAt:(NSIndexPath *) indexPath];
	//NSLog(@"The data:%@", data);
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:data];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


@end
