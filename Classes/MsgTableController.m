    //
//  MsgTableController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "MsgTableController.h"
#import "MsgDetailController.h"
#import "KKMsgDetailController.h"
#import "UserModel.h"
#import "ComposeMsgController.h"
#import "KKMsgListView.h"
#import "KKUserInfoController.h"
#import "KKDataVersionManager.h"


@implementation MsgTableController

@synthesize msgListView;

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
	//NSLog(@"loading front page.");
	//NSLog(@"loading msg table...");
	[super loadView];
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	NSString* identifier = [NSString stringWithFormat:@"%@.%@", @"frontpage", [[UserModel getInstance] getUserName]];
	msgListView = [[KKMsgListView alloc] initWithFrame:frame initWithUpdateURL:@"http://m.obanana.com/index.php/frontpage/" andIdentifier:identifier controller:nil];
	[self.view addSubview:msgListView];
	msgListView.delegate = self;
	self.navigationController.navigationBar.topItem.title = [[UserModel getInstance] getNickName];
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showCompose)];
	self.navigationItem.leftBarButtonItem = item;
	
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAll)];
	self.navigationItem.rightBarButtonItem = item2;
	[item release];
	[item2 release];
	
	if ([msgListView getMsgNum] == 0) {
		[msgListView refresh];
	}
	
    CGFloat tipWidth = 320;
    UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - tipWidth) / 2, 0, tipWidth, 30)];
	tipLabel.text = @"发表消息可获50积分";
    tipLabel.textAlignment = UITextAlignmentCenter;
	tipLabel.backgroundColor = [UIColor yellowColor];
	[self.view addSubview:tipLabel];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:3.0];
	[tipLabel setAlpha:0.0f];
	[UIView commitAnimations];
	[tipLabel release];

}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	/*
	MsgListController* msgListController = [[MsgListController alloc] init];
	self.view = msgListController.view;
	self.navigationController.navigationBar.topItem.title = [[UserModel getInstance] getNickName];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showCompose)];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
	
	composeController = [[ComposeMsgController alloc] init];
	 */

}

/*
-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	NSLog(@"here !!!");
	if ([[KKDataVersionManager getInstance] shouldUpdate:@"frontpage"]) {
		[self.msgListView cleanAll];
		[self.msgListView refresh];
		[[KKDataVersionManager getInstance] updated:@"frontpage"];
	}
}*/

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
	[msgListView release];
    [super dealloc];
}

-(IBAction) showDetail {
	MsgDetailController* msgDetailController = [[MsgDetailController alloc] init];
	msgDetailController.hidesBottomBarWhenPushed = YES;
	
	[self.navigationController pushViewController:msgDetailController animated:YES];
	[msgDetailController release];
}

-(IBAction) showCompose {
	ComposeMsgController* controller = [[ComposeMsgController alloc] init];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

/*
 
 -(void) msgListView:(KKMsgListView *) listView didLongTouchAt:(NSIndexPath *) indexPath;
 -(void) msgListView:(KKMsgListView *) listView didTouchAt:(NSIndexPath *) indexPath;
 -(void) msgListView:(KKMsgListView *) listView didAuthorImageViewClicked:(NSIndexPath *) indexPath;
 */
 -(void) msgListView:(KKMsgListView *) listView didLongTouchAt:(NSIndexPath *) indexPath{
	NSDictionary* data = [msgListView getMsgDataAt:(NSIndexPath *) indexPath];
	ComposeMsgController* composeController = [[ComposeMsgController alloc] initWithReplyData:data];
	[self presentModalViewController:composeController animated:YES];
	[composeController release];
}

 -(void) msgListView:(KKMsgListView *) listView didTouchAt:(NSIndexPath *) indexPath {
	// NSLog(@"Trigger Touch");
	KKMsgDetailController* controller = [[KKMsgDetailController alloc] initWithMsg:[msgListView getMsgDataAt:indexPath]];
	 controller.msgListView = self.msgListView;
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

 -(void) msgListView:(KKMsgListView *) listView didAuthorImageViewClicked:(NSIndexPath *) indexPath {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
	NSDictionary* data = [msgListView getMsgDataAt:(NSIndexPath *) indexPath];
	[userInfo setObject:[data objectForKey:@"user_nick"] forKey:@"user_nick"];
		[userInfo setObject:[data objectForKey:@"user_name"] forKey:@"user_name"];
		[userInfo setObject:[data objectForKey:@"head_image_id"] forKey:@"head_image_id"];
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:userInfo];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[userInfo release];
}

-(void) refresh {
	[self.msgListView refresh];
}

-(void) refreshAll {
	[self.msgListView cleanAll];
	[self.msgListView refresh];
}
@end
