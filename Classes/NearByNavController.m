    //
//  NearByNavController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "NearByNavController.h"
#import "MsgDetailController.h"
#import "KKMsgDetailController.h"
#import "UserModel.h"
#import "ComposeMsgController.h"
#import "KKMsgListView.h"
#import "KKUserInfoController.h"
#import "KKLocationAdjustController.h"
#import "KKUserListView.h"
#import "KKBoundCalculator.h"
#import "UtilModel.h"
#import "KKFootprintModel.h"

@implementation NearByNavController

@synthesize msgListView;
@synthesize location;
@synthesize lastSelectDate;
@synthesize userListView;
@synthesize followListView;
@synthesize segmentedControl;
@synthesize lastAcceleration;

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
	self.title = @"附近";
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	msgListView = [[KKMsgListView alloc] initWithFrame:frame initWithUpdateURL:@"http://m.obanana.com/index.php/frontpage/" andIdentifier:nil controller:nil];
	[self.view addSubview:msgListView];
	
	userListView = [[KKUserListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	userListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[userListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/user/%@/", [[UserModel getInstance] getUserName]]];
	userListView.userListdelegate = self;
	[self.view addSubview:userListView];
	
	followListView = [[KKUserListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	followListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[followListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/user/%@/", [[UserModel getInstance] getUserName]]];
	followListView.userListdelegate = self;
	[self.view addSubview:followListView];
	
	msgListView.delegate = self;
	//self.navigationController.navigationBar.topItem.title = @"附近消息";
	UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showCompose)];
	self.navigationItem.leftBarButtonItem = item;
	[item release];
	// - (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

	
	UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"GPSIconSmall.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showLocationAdjust)];
	self.navigationItem.rightBarButtonItem = item2;
	[item2 release];
	
	self.location = nil;
	
	//- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
	// UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"正在GPS定位" message:@"也可以点右上角的按钮手动定位" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	// [alert show];
	UIView* mask = [[UIView alloc] initWithFrame:msgListView.frame];
	UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, mask.frame.size.height / 2 - 100, mask.frame.size.width, 20)];
	label1.text = @"正在GPS定位...";
	label1.textAlignment = UITextAlignmentCenter;
	label1.backgroundColor = [UIColor clearColor];
	label1.font = [UIFont boldSystemFontOfSize:13.0f];
	label1.textColor =  [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
	[mask addSubview:label1];
	[label1 release];
	
	
	UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, mask.frame.size.height / 2 - 70, mask.frame.size.width, 20)];
	label2.text = @"你也可以按右上角按钮手动定位";
	label2.textAlignment = UITextAlignmentCenter;
	label2.backgroundColor = [UIColor clearColor];
	label2.font = [UIFont boldSystemFontOfSize:10.0f];
	label2.textColor =  [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:237.0/255.0 alpha:1.0];
	[mask addSubview:label2];
	[label2 release];
	
	UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20.f, 20.f)]; 
	[activityIndicator setCenter:CGPointMake(mask.frame.size.width / 2, mask.frame.size.height / 2 - 40)];
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[mask addSubview:activityIndicator];
	[activityIndicator startAnimating];
	[activityIndicator release];
	mask.backgroundColor =  [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
	[self.view addSubview:mask];
	[mask release];
	mask.tag = 123321;
	mask.hidden = NO;
	
	mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
	mapView.showsUserLocation = NO;
	mapView.delegate = self;
	
	[self findLocation];
	lastSelectDate = nil;
	
	
	NSArray *itemArray = [NSArray arrayWithObjects:@"消息", @"用户", @"圈子",nil];
	segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.frame = CGRectMake(0, 0, 200, 30);
	self.navigationItem.titleView = segmentedControl;
	
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(pickSegmentControl:) forControlEvents:UIControlEventValueChanged];
	

	
	msgListViewRefresh = NO;
	userListViewRefresh = NO;
	followListViewRefresh = NO;
	
	msgListView.hidden = NO;
	userListView.hidden = YES;
	followListView.hidden = YES;
    
    [UIAccelerometer sharedAccelerometer].delegate = self;

    //[self becomeFirstResponder];
    
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
-(BOOL)canBecomeFirstResponder {
    NSLog(@"here1");
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"view appear ...");
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"shake is triggered.");
    }
}*/


static BOOL L0AccelerationIsShaking(UIAcceleration* last, UIAcceleration* current, double threshold) {
    double
    deltaX = fabs(last.x - current.x),
    deltaY = fabs(last.y - current.y),
    deltaZ = fabs(last.z - current.z);
    
    return
    (deltaX > threshold && deltaY > threshold) ||
    (deltaX > threshold && deltaZ > threshold) ||
    (deltaY > threshold && deltaZ > threshold);
}

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
    if (self.lastAcceleration != nil) {
        if (!histeresisExcited && L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.7)) {
            histeresisExcited = YES;
            
            /* SHAKE DETECTED. DO HERE WHAT YOU WANT. */
            //NSLog(@"shaking...");
            [self findLocation];
        } else if (histeresisExcited && !L0AccelerationIsShaking(self.lastAcceleration, acceleration, 0.2)) {
            histeresisExcited = NO;
        }
    }
    
    self.lastAcceleration = acceleration;
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
	[msgListView release];
	[location release];
	[mapView release];
	[lastSelectDate release];
	[userListView release];
	[followListView release];
	[segmentedControl release];
    [lastAcceleration release];
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


-(void) msgListView:(KKMsgListView *) listView didLongTouchAt:(NSIndexPath *) indexPath {
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
	//KKUserInfoController* controller = [[KKUserInfoController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	[userInfo release];
	
}

-(void) showLocationAdjust {
	KKLocationAdjustController* controller = [[KKLocationAdjustController alloc] initWithLocation:self.location];
	controller.delegate = self;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}


-(void) resetLocation:(CLLocation*) _location {
	[[KKFootprintModel getInstance] sendFootprint:_location];
	mapView.showsUserLocation = NO;
	UIView* mask = [self.view viewWithTag:123321];
	mask.hidden = YES;
	self.location = _location;
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/nearby/index/%.5lf/%.5lf/", self.location.coordinate.longitude, 
					 self.location.coordinate.latitude];
	[msgListView setURL:url];
	KKBound bound = [KKBoundCalculator calcBound:_location.coordinate radius:140];
	[userListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/nearby/user/%.5lf,%.5lf,%.5lf,%.5lf/", 
	bound.minLng, bound.minLat, bound.maxLng, bound.maxLat]];
	[followListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/nearby/follow/%.5lf,%.5lf,%.5lf,%.5lf/", 
							bound.minLng, bound.minLat, bound.maxLng, bound.maxLat]];
	
	msgListViewRefresh = YES;
	userListViewRefresh = YES;
	followListViewRefresh = YES;
	
	KKBaseListView* base = nil;
	if (segmentedControl.selectedSegmentIndex == 0) {
		//base = msgListView;
		[msgListView cleanAll];
		[msgListView refresh];
		msgListViewRefresh = NO;
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		base = userListView;
		userListViewRefresh = NO;
	} else if (segmentedControl.selectedSegmentIndex == 2) {
		base = followListView;
		followListViewRefresh = NO;
	}
	if (base != nil) {
		[base cleanAll];
		[base refresh];
	}

}

-(void) onsave:(CLLocation *) _location {
	[self resetLocation:_location];
}

-(void) findLocation {
	mapView.showsUserLocation = YES;
	UIView* mask = [self.view viewWithTag:123321];
	mask.hidden = NO;
}

-(void)mapView:(MKMapView *)_mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
	[self resetLocation:newLocation];
	[newLocation release];
	mapView.showsUserLocation = NO;
}

/*
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	if (navigationController.topViewController == viewController && viewController == self) {
		NSLog(@"should trigger relocation");
	}
}
 */

-(void) didSelected {
	//NSLog(@"selected ...");
	NSDate* current = [NSDate date];
	if (lastSelectDate != nil && [current timeIntervalSinceDate:lastSelectDate] < 1.0) {
		[self findLocation];
	}
	self.lastSelectDate = current;
								  
}


-(void) pickSegmentControl:(id) sender {
	
	msgListView.hidden = YES;
	userListView.hidden = YES;
	followListView.hidden = YES;
	
	if (segmentedControl.selectedSegmentIndex == 0) {
		msgListView.hidden = NO;
		if (msgListViewRefresh) {
			[msgListView cleanAll];
			[msgListView refresh];
			msgListViewRefresh = NO;
		}
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		userListView.hidden = NO;
		if (userListViewRefresh) {
			[userListView cleanAll];
			[userListView refresh];
			userListViewRefresh = NO;
		}
	} else if (segmentedControl.selectedSegmentIndex == 2) {
		followListView.hidden = NO;
		if (followListViewRefresh) {
			[followListView cleanAll];
			[followListView refresh];
			followListViewRefresh = NO;
		}
	}
}

-(void) userList:(KKUserListView*) userList didTouchAt:(NSIndexPath *) indexPath; {
	NSDictionary* data = [userList getMsgDataAt:(NSIndexPath *) indexPath];
	//NSLog(@"The data:%@", data);
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:data];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(NSString *) userList:(KKUserListView*) userList modifyDescriptionLabelText:(NSString *) description {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* date2 =  [formatter stringFromDate:[NSDate date]];
	[formatter release];
	NSString* result = [[UtilModel getInstance] getReadableDateDiffBetweenDate1:description andDate2:date2];
	if ([result isEqualToString:@"刚刚"]) {
		return [NSString stringWithFormat:@"刚刚在这里"];
	} else {
		return [NSString stringWithFormat:@"%@前在这里", result];
	}
	
}
@end
