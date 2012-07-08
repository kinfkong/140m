    //
//  KKMsgDetailController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-27.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgDetailController.h"
#import "UIImageView+ASYNC.h"
#import <QuartzCore/QuartzCore.h>
#import "KKTemplateRender.h"
#import "KKTweetParser.h"
#import "KKImageBrowseController.h"
#import "KKMapController.h"
#import "KKUserInfoController.h"
#import "KKWebBrowserController.h"
#import "ComposeMsgController.h"
#import "KKAllReplyController.h"
#import "UserModel.h"
#import "UtilModel.h"
#import "KKNetworkLoadingView.h"
#import "KKDefaultMsgController.h"

#define KKAHURORHEADER_HEIGHT 70

@interface KKMsgDetailController (private)
-(void) ComposePrivate;
@end
    
@implementation KKMsgDetailController

@synthesize data;
@synthesize msgListView;

-(id) initWithMsg:(NSDictionary *) msg {
	self = [super init];
	if (self != nil) {
		self.data = msg;
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
	self.title = @"详情";
	UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, KKAHURORHEADER_HEIGHT)];
	headerView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
	[self.view addSubview:headerView];
	
	UIImageView* authorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [self.data objectForKey:@"head_image_id"]];
	[authorImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:nil];
	[headerView addSubview:authorImageView];
	authorImageView.layer.masksToBounds = YES;
	authorImageView.layer.cornerRadius = 4.0;
	authorImageView.layer.borderWidth = 0.0;
	authorImageView.layer.borderColor = [[UIColor clearColor] CGColor];
	
	authorImageView.userInteractionEnabled = YES;
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAuthorImageViewClicked:)];
	[authorImageView addGestureRecognizer:singleTap];
	[singleTap release];
	[authorImageView release];
	
	UILabel* authorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 320 - 80, 20)];
	authorNameLabel.backgroundColor = [UIColor clearColor];
	authorNameLabel.text = [self.data objectForKey:@"user_nick"];
	authorNameLabel.textColor = [UIColor whiteColor];
	authorNameLabel.font = [UIFont systemFontOfSize:17];
	
	[headerView addSubview:authorNameLabel];
	[authorNameLabel release];
	
	UIButton* replyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	replyButton.frame = CGRectMake(80, 38, 90, 25);
	[replyButton setTitle:@"回复" forState:UIControlStateNormal];
	[replyButton addTarget:self action:@selector(showCompose) forControlEvents:UIControlEventTouchUpInside];
	[headerView addSubview:replyButton];
	
	
	UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	moreButton.frame = CGRectMake(185, 38, 90, 25);
	
	if ([self.data objectForKey:@"to_user"] != nil) {
		[moreButton setTitle:@"删除私信" forState:UIControlStateNormal];
		[moreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
		[moreButton addTarget:self action:@selector(deletePrivateMsg) forControlEvents:UIControlEventTouchUpInside];
	} else {
		[moreButton setTitle:@"更多" forState:UIControlStateNormal];
		[moreButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
	}
	[headerView addSubview:moreButton];
	
	[headerView release];
	
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, KKAHURORHEADER_HEIGHT, 320, self.view.frame.size.height - KKAHURORHEADER_HEIGHT)];
	
	webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	webView.delegate = self;
	[self.view addSubview:webView];
	/*
	UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
	topLabel.text = @"This is the top";
	topLabel.backgroundColor = [UIColor blueColor];
	scrollView = nil;
	for (id subview in webView.subviews){ 
		if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
			scrollView = subview;
			scrollView.alwaysBounceVertical = YES;
			scrollView.alwaysBounceHorizontal = NO;
			scrollView.contentInset = UIEdgeInsetsMake(65, 0, 0, 0);
			break;
		}
	}
	[webView insertSubview:topLabel belowSubview:scrollView];
	[topLabel release];
	*/
	NSBundle* bundle = [NSBundle mainBundle];
	NSString*  resPath = [bundle resourcePath];
	NSString* filePath = [resPath stringByAppendingPathComponent:@"KKMsgDetailTemp.html"];
	NSString* pageTemplate = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	NSMutableDictionary* viewdata = [[NSMutableDictionary alloc] init];
	
	NSString* msg = [data objectForKey:@"msg"];
	if (msg == nil) {
		msg = @"";
	}
	msg = [KKTweetParser display:msg withDisplayType:KKTweetDisplayRichType];
	[viewdata setObject:msg forKey:@"msg"];
	[viewdata setObject:[self.data objectForKey:@"id"] forKey:@"replyMsgIdToShow"];
	NSString* imageId = [data objectForKey:@"image_id"];
	NSString* imageShow = @"0";
	NSString* replyShow = @"0";
	if (imageId != nil) {
		imageShow = @"1";
		[viewdata setObject:imageId forKey:@"imageId"];
	} 
	NSDictionary* replyMsg = [data objectForKey:@"reply_msg"];
	NSString* replyDel = [replyMsg objectForKey:@"del"];
	if (replyMsg != nil && imageId == nil && [replyDel isEqualToString:@"0"]) {
		replyShow = @"1";
	} 
	
	
	NSString* replyImageShow = @"0";
	if (replyMsg != nil && imageId == nil) {
		NSString* replyMsgContent = [replyMsg objectForKey:@"msg"];
		if (replyMsgContent == nil) {
			replyMsgContent = @"";
		}
		[viewdata setObject:[replyMsg objectForKey:@"id"] forKey:@"replyMsgIdToShow"];
		[viewdata setObject:[replyMsg objectForKey:@"user_name"] forKey:@"replyAuthorName"];
		[viewdata setObject:[replyMsg objectForKey:@"user_nick"] forKey:@"replyAuthorNick"];
		[viewdata setObject:[replyMsg objectForKey:@"create_time"] forKey:@"replyTimestamp"];
		replyMsgContent = [KKTweetParser display:replyMsgContent withDisplayType:KKTweetDisplayRichType];
		[viewdata setObject:replyMsgContent forKey:@"replyMsg"];
		NSString* replyImageId = [replyMsg objectForKey:@"image_id"];
		if (replyImageId != nil) {
			replyImageShow = @"1";
			[viewdata setObject:replyImageId forKey:@"replyImageId"];
		}
		
	}
	//NSLog(@"The reply image show:%@", replyImageShow);
	NSString* lat = [data objectForKey:@"lat"];
	NSString* lng = [data objectForKey:@"lng"];
	if (replyMsg != nil && imageId == nil && [replyDel isEqualToString:@"0"]) {
		lat = [[data objectForKey:@"reply_msg"] objectForKey:@"lat"];
		lng = [[data objectForKey:@"reply_msg"] objectForKey:@"lng"];
	}
	
	NSString* fromLocation = [data objectForKey:@"fromlocation"];
	if (fromLocation == nil || [fromLocation isEqualToString:@""]) {
		[viewdata setObject:@"0" forKey:@"hasComefrom"];
	} else {
		[viewdata setObject:@"1" forKey:@"hasComefrom"];
		if ([fromLocation isEqualToString:@"##system:140m##"]) {
			fromLocation = @"140m";
		} else if ([fromLocation isEqualToString:@"##system:nearby##"]) {
			fromLocation = @"附近";
		}
		[viewdata setObject:fromLocation forKey:@"fromLocation"];
	}
	[viewdata setObject:imageShow forKey:@"imageShow"];
	[viewdata setObject:replyShow forKey:@"replyShow"];
	[viewdata setObject:replyImageShow forKey:@"replyImageShow"];
	[viewdata setObject:lat forKey:@"lat"];
	[viewdata setObject:lng forKey:@"lng"];
	
	[viewdata setObject:[data objectForKey:@"create_time"] forKey:@"timestamp"];
	
	
	
	pageTemplate = [KKTemplateRender render:pageTemplate withData:viewdata];
	//NSLog(@"%@", pageTemplate);
	[viewdata release];
	[webView loadHTMLString:pageTemplate baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
	
	// [webView loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;];
	// [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
}

-(void) onAuthorImageViewClicked:(id) sender {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
	//NSDictionary* data = [msgListView getMsgDataAt:(NSIndexPath *) indexPath];
	[userInfo setObject:[self.data objectForKey:@"user_nick"] forKey:@"user_nick"];
	[userInfo setObject:[self.data objectForKey:@"user_name"] forKey:@"user_name"];
	[userInfo setObject:[self.data objectForKey:@"head_image_id"] forKey:@"head_image_id"];
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:userInfo];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[userInfo release];
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
	[data release];
	[webView release];
	[msgListView release];
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *requestString = [[request URL] absoluteString];	
	NSArray *components = [requestString componentsSeparatedByString:@":"];
	if ([components count] >= 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"obanana"]) {
		if ([components count] == 3 && [[components objectAtIndex:1] isEqualToString:@"showfullimage"]) {
			NSString* imageId = [components objectAtIndex:2];
			KKImageBrowseController* controller = [[KKImageBrowseController alloc] initWithImageId:imageId];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		if ([components count] == 3 && [[components objectAtIndex:1] isEqualToString:@"showmap"]) {
			CLLocationCoordinate2D location;
			NSString* LngLatStr = [components objectAtIndex:2];
			NSArray* lngLatArray = [LngLatStr componentsSeparatedByString:@","];
			NSString* lngStr = [lngLatArray objectAtIndex:0];
			NSString* latStr = [lngLatArray objectAtIndex:1];
			location.longitude = [lngStr doubleValue];
			location.latitude = [latStr doubleValue];
			KKMapController* controller = [[KKMapController alloc] initWithLocation2D:location];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}

		if ([components count] == 3 && [[components objectAtIndex:1] isEqualToString:@"showuserinfo"]) {
			NSString* userName = [components objectAtIndex:2];
			KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserName:userName];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		if ([components count] == 3 && [[components objectAtIndex:1] isEqualToString:@"showallreply"]) {
			NSString* msgId = [components objectAtIndex:2];
			KKAllReplyController* controller = [[KKAllReplyController alloc] initWithMsgId:msgId];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		if ([components count] > 3 && [[components objectAtIndex:1] isEqualToString:@"jumpto"]) {
			NSString* url = [requestString substringFromIndex:[@"obanana:jumpto:" length]];
			KKWebBrowserController* controller = [[KKWebBrowserController alloc] initWithBaseURL:url];
			
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		//NSLog(@"the whole str:%@, second:%@", requestString, [components objectAtIndex:1]);
		if ([components count] >= 3 && [[components objectAtIndex:1] isEqualToString:@"showtopic"]) {
			NSString* topic = [requestString substringFromIndex:[@"obanana:showtopic:" length]];
			// NSLog(@"the topic:%@", topic);
			/*
			topic = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																						   NULL,
																						   (CFStringRef)topic,
																						   NULL,
																						   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						   kCFStringEncodingUTF8 );
			 */
			NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/post/topic/%@/", topic];
			KKDefaultMsgController* controller = [[KKDefaultMsgController alloc] initWithMsgURL:url];
			controller.title = [NSString stringWithFormat:@"%@", @"话题"];
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
		
		return NO;	
	} 	
	return YES;
	
}


-(void) showCompose {
    if ([self.data objectForKey:@"to_user"] != nil) {
		[self ComposePrivate];
        return;
	}
    
	ComposeMsgController* controller = [[ComposeMsgController alloc] initWithReplyData:self.data];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

-(void) showMore {
	if ([[self.data objectForKey:@"user_name"] isEqualToString:[[UserModel getInstance] getUserName]]) {
		UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:@"选择你要进行的操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除此消息" otherButtonTitles:nil, nil];
		[menu showInView:self.view];
		[menu release];
	} else {
		UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:@"选择你要进行的操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"私信", nil];
		[menu showInView:self.view];
		[menu release];
	}
}

-(void) deleteMsg {
	//NSLog(@"trigger delete");
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定删除此微博?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}

-(void) deletePrivateMsg {
	//NSLog(@"trigger delete");
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"确定删除此私信?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
	[alert show];
	[alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSString* msgId = [self.data objectForKey:@"mid"];
		if (msgId == nil) {
			return;
		}
		
		UtilModel* utilModel = [UtilModel getInstance];
		NSMutableDictionary* modificationData = [[NSMutableDictionary alloc] init];
		[modificationData setObject:[[UserModel getInstance] getToken] forKey:@"token"];

		NSString* urlstr = [NSString stringWithFormat:@"http://m.obanana.com/index.php/post/del/%@", msgId];
		
		if ([self.data objectForKey:@"to_user"] != nil) {
			urlstr = [NSString stringWithFormat:@"http://m.obanana.com/index.php/privatemail/del/%@", [self.data objectForKey:@"id"]];
		}
		
		NSURLRequest* request = [utilModel generateRequesWithURL:urlstr
												  PostDictionary:modificationData];
		[modificationData release];
		KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self];
		[self.view addSubview:loadingView];
		[loadingView release];
		
	}
}

-(void) ComposePrivate {
	NSMutableDictionary* userInfo = [[NSMutableDictionary alloc] init];
	//NSDictionary* data = [msgListView getMsgDataAt:(NSIndexPath *) indexPath];
	[userInfo setObject:[self.data objectForKey:@"user_nick"] forKey:@"user_nick"];
	[userInfo setObject:[self.data objectForKey:@"user_name"] forKey:@"user_name"];
	[userInfo setObject:[self.data objectForKey:@"head_image_id"] forKey:@"head_image_id"];
	ComposeMsgController* controller = [[ComposeMsgController alloc] initWithPrivateMail:userInfo];
	[self presentModalViewController:controller animated:YES];
	[controller release];
	[userInfo release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	BOOL myMsg = NO;
	if ([[self.data objectForKey:@"user_name"] isEqualToString:[[UserModel getInstance] getUserName]]) {
		myMsg = YES;
	}
	if (myMsg && buttonIndex == 0) {
		[self deleteMsg];
	} else if (!myMsg && buttonIndex == 0) {
		[self ComposePrivate];
	}
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) responsedata {
	if (![[responsedata objectForKey:@"errno"] isEqualToString:@"0"]) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"可以尝试重新登录后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	if (self.navigationController.topViewController == self) {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	[self.msgListView cleanAll];
	[self.msgListView refresh];
}

-(void) view:(KKNetworkLoadingView *) sender onFailedLoading:(NSError *) error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"删除失败" message:@"请检查网络或重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(NSString*) loadingMessageForView:(KKNetworkLoadingView *) sender {
	return @"正在删除";
}

-(NSString*) failedMessageForView:(KKNetworkLoadingView *) sender {
	return @"删除失败";
}

@end
