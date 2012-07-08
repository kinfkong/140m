    //
//  KKSearchController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-17.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKSearchController.h"
#import "KKUserListView.h"
#import "KKUserInfoController.h"


@implementation KKSearchController

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
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.title = @"搜索用户";
	
	UISearchBar* searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	searchBar.delegate = self;
	[self.view addSubview:searchBar];
	[searchBar becomeFirstResponder];
	[searchBar release];
	
	KKUserListView* userListView = [[KKUserListView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
	userListView.userListdelegate = self;
	userListView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	userListView.tag = 100;
	[self.view addSubview:userListView];
	[userListView release];
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
    [super dealloc];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	KKUserListView* userListView = (KKUserListView*) [self.view viewWithTag:100];
	NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)searchBar.text,
																				   NULL,
																				   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																				   kCFStringEncodingUTF8 );
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/search/%@/", encodedString];
	[userListView setURL:url];
	[userListView cleanAll];
	[userListView refresh];
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
