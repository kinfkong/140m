    //
//  ForyouNavController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "ForyouNavController.h"
#import "ComposeMsgController.h"
#import "KKMsgDetailController.h"
#import "KKUserInfoController.h"
#import "UserModel.h"

@implementation ForyouNavController

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
	NSArray *itemArray = [NSArray arrayWithObjects:@"@我的", @"私信", nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 180, 30);
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl release];
	
	
	[segmentedControl addTarget:self action:@selector(pickSegmentControl:) forControlEvents:UIControlEventValueChanged];
	
	/*
	privateMsgListView = [[KKMsgListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) initWithUpdateURL:@"http://m.obanana.com/index.php/frontpage/" andIdentifier:nil];
	[self.view addSubview:privateMsgListView];
	privateMsgListView.delegate = self;
	 */
	
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/privatemail/index/%@", [[UserModel getInstance] getUserName]];
	privateMsgListView = [[KKMsgListView alloc] initWithFrame:frame initWithUpdateURL:url andIdentifier:nil];
	privateMsgListView.delegate = self;
	[self.view addSubview:privateMsgListView];
	
	url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/atme/index/%@", [[UserModel getInstance] getUserName]];
	atmeMsgListView = [[KKMsgListView alloc] initWithFrame:frame initWithUpdateURL:url andIdentifier:nil];
	atmeMsgListView.delegate = self;
	[self.view addSubview:atmeMsgListView];
	
	privateMsgListViewRefreshed = NO;
	atmeMsgListViewRefreshed = NO;
	
	privateMsgListView.hidden = YES;
	segmentedControl.selectedSegmentIndex = 0;
	
	UIBarButtonItem *freshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshForyou:)];
	self.navigationItem.rightBarButtonItem = freshItem;
	[freshItem release];
	
}


-(void) refreshForyou:(id) sender {
	if (segmentedControl.selectedSegmentIndex == 0) {
		[atmeMsgListView cleanAll];
		[atmeMsgListView refresh];
	} else {
		[privateMsgListView cleanAll];
		[privateMsgListView refresh];
	}
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    /*[super viewDidLoad];
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	label.text = @"This is foryou";
	[self.view addSubview:label];
	[label release];
	 */
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
	[privateMsgListView release];
	[atmeMsgListView release];
    [super dealloc];
}

-(void) pickSegmentControl:(id) sender {
	privateMsgListView.hidden = YES;
	atmeMsgListView.hidden = YES;
	if (segmentedControl.selectedSegmentIndex == 0) {
		atmeMsgListView.hidden = NO;
		if (atmeMsgListViewRefreshed == NO) {
			atmeMsgListViewRefreshed = YES;
			[atmeMsgListView cleanAll];
			[atmeMsgListView refresh];
		}
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		
		privateMsgListView.hidden = NO;
		if (privateMsgListViewRefreshed == NO) {
			privateMsgListViewRefreshed = YES;
			[privateMsgListView cleanAll];
			[privateMsgListView refresh];
		}
	}
}	


-(void) msgListView:(KKMsgListView*) listView didLongTouchAt:(NSIndexPath *) indexPath  {
	NSDictionary* data = [listView getMsgDataAt:(NSIndexPath *) indexPath];
	ComposeMsgController* composeController = [[ComposeMsgController alloc] initWithReplyData:data];
	[self presentModalViewController:composeController animated:YES];
	[composeController release];
}

-(void) msgListView:(KKMsgListView*) listView didTouchAt:(NSIndexPath *) indexPath {
	// NSLog(@"Trigger Touch");
	KKMsgDetailController* controller = [[KKMsgDetailController alloc] initWithMsg:[listView getMsgDataAt:indexPath]];
	controller.msgListView = privateMsgListView;
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) msgListView:(KKMsgListView*) listView didAuthorImageViewClicked:(NSIndexPath *) indexPath {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
	NSDictionary* data = [listView getMsgDataAt:(NSIndexPath *) indexPath];
	[userInfo setObject:[data objectForKey:@"user_nick"] forKey:@"user_nick"];
	[userInfo setObject:[data objectForKey:@"user_name"] forKey:@"user_name"];
	[userInfo setObject:[data objectForKey:@"head_image_id"] forKey:@"head_image_id"];
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:userInfo];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[userInfo release];
}



@end
