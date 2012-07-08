    //
//  KKAboutController.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-14.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKAboutController.h"
#import "KKWebBrowserController.h"
#import "KKUserInfoController.h"
#import "KKAllReplyController.h"
#import "KKMapController.h"
#import "KKImageBrowseController.h"

@implementation KKAboutController

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
	self.title = @"关于";
	UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	bgImageView.image = [UIImage imageNamed:@"login_bg.jpg"];
	float rotateAngle = 3.141592653;
	CGAffineTransform transform =CGAffineTransformMakeRotation(rotateAngle);
	bgImageView.transform = transform;
	[self.view addSubview:bgImageView];
	[bgImageView release];
	
	UIImageView* iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 100, 100)];
	iconImageView.image = [UIImage imageNamed:@"icon_trans.png"];
	[self.view addSubview:iconImageView];
	[iconImageView release];
	
	UILabel* versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 25, 150, 50)];
	versionLabel.backgroundColor = [UIColor clearColor];
	versionLabel.textColor = [UIColor whiteColor];
	versionLabel.text = [NSString stringWithFormat:@"140m 版本:%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
	[self.view addSubview:versionLabel];
	[versionLabel release];
	
	UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 100, 280, 300)];
	webView.backgroundColor = [UIColor clearColor];
	webView.delegate = self;
	
	NSBundle* bundle = [NSBundle mainBundle];
	NSString*  resPath = [bundle resourcePath];
	NSString* filePath = [resPath stringByAppendingPathComponent:@"AboutPage.html"];
	NSString* pageTemplate = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

	[webView loadHTMLString:pageTemplate baseURL:[NSURL fileURLWithPath:[bundle bundlePath]]];
	
	[self.view addSubview:webView];
	[webView release];
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
		return NO;	
	} 	
	return YES;
	
}


@end
