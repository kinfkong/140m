    //
//  MainTabController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "MainTabController.h"


#import "NearByNavController.h"
#import "ForyouNavController.h"
#import "FollowNavController.h"
#import "MoreNavController.h"
#import "MsgTableController.h"
#import "KKComposeManager.h"

@implementation MainTabController

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
	// create the tabBar
	barController = [[UITabBarController alloc] init];
	barController.delegate = self;
	UINavigationController* frontPage = [[UINavigationController alloc] init];
	frontPage.delegate = self;
	frontPage.tabBarItem.title = @"主页";
	frontPage.tabBarItem.image = [UIImage imageNamed:@"home_logo.png"];
	
	MsgTableController* msgTableController = [[MsgTableController alloc] init];
	[frontPage pushViewController:msgTableController animated:NO];
	
	UINavigationController* nearBy = [[UINavigationController alloc] init];
	nearBy.delegate = self;
	nearBy.tabBarItem.title = @"附近";
	nearBy.tabBarItem.image = [UIImage imageNamed:@"140m_tablogo.png"];
	
	NearByNavController* nearByController = [[NearByNavController alloc] init];
	[nearBy pushViewController:nearByController animated:NO];
	nearBy.delegate = nearByController;
	[nearByController release];
	
	
	UINavigationController* forYou = [[UINavigationController alloc] init];
	forYou.delegate = self;
	forYou.tabBarItem.title = @"消息";
	forYou.tabBarItem.image = [UIImage imageNamed:@"message_logo.png"];
	
	ForyouNavController* forYouController = [[ForyouNavController alloc] init];
	[forYou pushViewController:forYouController animated:NO];
	[forYouController release];
	
	UINavigationController* follow = [[UINavigationController alloc] init];
	follow.delegate = self;
	FollowNavController* followController = [[FollowNavController alloc] init];
	[follow pushViewController:followController animated:NO];
	[followController release];
	follow.tabBarItem.title = @"收听";
	follow.tabBarItem.image = [UIImage imageNamed:@"listen_logo.png"];
	
	UINavigationController* more = [[UINavigationController alloc] init];
	more.delegate = self;
	MoreNavController* moreController = [[MoreNavController alloc] init];
	[more pushViewController:moreController animated:NO];
	[moreController release];
	
	more.tabBarItem.title = @"更多";
	more.tabBarItem.image = [UIImage imageNamed:@"more_logo.png"];
	
	
	barController.viewControllers = [NSArray arrayWithObjects:frontPage, 
									 nearBy, forYou, follow, more, nil];
	
	self.view = barController.view;
	KKComposeManager* mgr = [KKComposeManager getInstance];
	[self.view addSubview:mgr.statusBarView];
	
	[frontPage release];
	[nearBy release];
	[forYou release];
	[follow release];
	[more release];
	[msgTableController release];
	//NSLog(@"the view:%@", self.view);
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
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

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
	if ([viewController isKindOfClass:[UINavigationController class]] && tabBarController.selectedIndex == 1) {
		// nearby
		UINavigationController* nearby = (UINavigationController *) viewController;
		if ([nearby.topViewController isKindOfClass:[NearByNavController class]]) {
			NearByNavController* nearyController = (NearByNavController *) nearby.topViewController;
			[nearyController didSelected];
		}
	}
	// NSLog(@"selected...");
}

- (void)dealloc {
	[barController release];
    [super dealloc];
}

- (void)navigationController:(UINavigationController *)navigationController 
	   didShowViewController:(UIViewController *)viewController animated:(BOOL)animated 
{
    [viewController viewDidAppear:animated];
}

@end
