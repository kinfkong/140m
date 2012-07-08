    //
//  KKAllReplyController.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-7.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKAllReplyController.h"
#import "ComposeMsgController.h"
#import "KKMsgDetailController.h"
#import "KKUserInfoController.h"

@implementation KKAllReplyController

@synthesize msgId;

-(id) initWithMsgId:(NSString *) _msgId {
	self = [super init];
	if (self != nil) {
		self.msgId = _msgId;
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
	self.title = @"查看所有回复";
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/post/allreply/%@", self.msgId];
	msgListView = [[KKMsgListView alloc] initWithFrame:frame initWithUpdateURL:url andIdentifier:nil];
	msgListView.replyHidden = YES;
	msgListView.delegate = self;
	[self.view addSubview:msgListView];
	[msgListView refresh];
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
	[msgId release];
	[msgListView release];
    [super dealloc];
}

-(void) msgListView:(KKMsgListView *) listView didLongTouchAt:(NSIndexPath *) indexPath {
	NSDictionary* data = [listView getMsgDataAt:(NSIndexPath *) indexPath];
	ComposeMsgController* composeController = [[ComposeMsgController alloc] initWithReplyData:data];
	[self presentModalViewController:composeController animated:YES];
	[composeController release];
}

-(void) msgListView:(KKMsgListView *) listView didTouchAt:(NSIndexPath *) indexPath {
	// NSLog(@"Trigger Touch");
	KKMsgDetailController* controller = [[KKMsgDetailController alloc] initWithMsg:[msgListView getMsgDataAt:indexPath]];
	controller.msgListView = msgListView;
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) msgListView:(KKMsgListView *) listView didAuthorImageViewClicked:(NSIndexPath *) indexPath {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
	NSDictionary* data = [listView getMsgDataAt:(NSIndexPath *) indexPath];
	[userInfo setObject:[data objectForKey:@"user_nick"] forKey:@"user_nick"];
	[userInfo setObject:[data objectForKey:@"user_name"] forKey:@"user_name"];
	[userInfo setObject:[data objectForKey:@"head_image_id"] forKey:@"head_image_id"];
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:userInfo];
	//KKUserInfoController* controller = [[KKUserInfoController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[userInfo release];
	
}


@end
