    //
//  KKLocationAdjustController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-3.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKLocationAdjustController.h"
#import "KKMapAnnotation.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "KKBoundCalculator.h"
#import "KKNetworkLoadingView.h"
#import "UserModel.h"
#import "UtilModel.h"
#import "ModalAlert.h"

@interface KKLocationAdjustController () 
- (void)coordinateChanged_:(NSNotification *)notification;
-(void) removeAllPins;
@end


@implementation KKLocationAdjustController

@synthesize location;
@synthesize delegate;

-(id) init {
	return [self initWithLocation:nil];
}

-(id) initWithAddLocationStyle {
	
	self = [self initWithLocation:nil];
	addLocation = YES;
	return self;
}

-(id) initWithLocation:(CLLocation*) _location {
	self = [super init];
	if (self != nil) {
		self.location = _location;
		addLocation = NO;
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

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];	
}

// Override to allow orientations other than the default portrait orientation.
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return ;
}*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	UINavigationBar* bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[self.view addSubview:bar];
	[bar release];
	
	UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAll:)];
	UIBarButtonItem* saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
	UIBarButtonItem* confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(confirmAddLocation:)];
	UINavigationItem* items = [[UINavigationItem alloc] initWithTitle:@"调整当前位置"];
	
	items.leftBarButtonItem = cancelItem;
	if (addLocation) {
		items.rightBarButtonItem = confirmItem;
		items.title = @"收听地点";
	} else {
		items.rightBarButtonItem = saveItem;
	}
	[cancelItem release];
	[saveItem release];
	[confirmItem release];
	[bar pushNavigationItem:items animated:NO];
	[items release];

	//- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
	
	CGRect frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40);
	mapView = [[MKMapView alloc] initWithFrame:frame];
	mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.view addSubview:mapView];
	
	mapView.showsUserLocation = NO;
	mapView.delegate = self;
	
	if (location != nil) {
		mapView.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000.0f, 1000.0f);
	}
	
	
	NSArray *itemArray = [NSArray arrayWithObjects:@"手动定位", @"GPS定位", nil];
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
	segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
	segmentedControl.frame = CGRectMake((320 - 250) / 2, mapView.frame.size.height - 20, 250, 40);
	[self.view addSubview:segmentedControl];
	[segmentedControl release];
	segmentedControl.selectedSegmentIndex = 0;
	[segmentedControl addTarget:self action:@selector(pickSegmentControl:) forControlEvents:UIControlEventValueChanged];
	[self setPinAt:self.location];
	
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.f, 20.f)]; 
	[activityIndicator setCenter:CGPointMake(segmentedControl.frame.origin.x + segmentedControl.frame.size.width - 10, segmentedControl.frame.origin.y + segmentedControl.frame.size.height / 2)]; 
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
	[self.view addSubview:activityIndicator];
	
	
	UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
	//map 为mkmapview的实例
    [mapView addGestureRecognizer:lpress];
    [lpress release];    
	
	CGFloat tipWidth = 250;
	
	UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((320 - tipWidth) / 2, 50, tipWidth, 30)];
	tipLabel.text = @"秘技: 长按地图可以放置大头针";
	tipLabel.backgroundColor = [UIColor yellowColor];
	[self.view addSubview:tipLabel];
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:4.0];
	[tipLabel setAlpha:0.0f];
	[UIView commitAnimations];
	[tipLabel release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


// Override to allow orientations other than the default portrait orientation.
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
	return NO;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	[activityIndicator release];
	[mapView release];
	[location release];
	[delegate release];
    [super dealloc];
}

-(void) cancelAll:(id) obj {
	if ([delegate respondsToSelector:@selector(oncancel:)]) {
		[delegate oncancel:self.location];
	}
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

- (void)mapView:(MKMapView *)_mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1000.0f, 1000.0f);
	self.location = userLocation.location;
	[activityIndicator stopAnimating];

		[self removeAllPins];
}

-(void) setPinAt:(CLLocation *) _location {
	if (_location == nil) {
		return;
	}
	[self removeAllPins];
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:_location.coordinate addressDictionary:nil] autorelease];
	annotation.title = @"长按大头针底部后可以拖动大头针";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	[mapView addAnnotation:annotation];	
}

-(void) removeAllPins {
	NSMutableArray* toRemove = [[NSMutableArray alloc] init];
	for (id annotation in mapView.annotations) {
		if ([annotation isKindOfClass:[DDAnnotation class]]) {
			//[mapView removeAnnotation:annotation];
			[toRemove addObject:annotation];
		}
	}
	for (id annotation in toRemove) {
		[mapView removeAnnotation:annotation];
	}
	[toRemove release];
}
-(void) pickGPS {
	mapView.showsUserLocation = YES;
	[activityIndicator startAnimating];
}

-(void) pickHand {
	[activityIndicator stopAnimating];
	mapView.showsUserLocation = NO;
	if (self.location != nil) {
		[self setPinAt:self.location];
	}
}

- (void) pickSegmentControl:(id)sender{
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	int index = [segmentedControl selectedSegmentIndex];
	if (index == 1) {
		[self pickGPS];
	} else if (index == 0) {
		[self pickHand];
	}
}


#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
	self.location = newLocation;
	[newLocation release];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];	
		CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
		self.location = newLocation;
		[newLocation release];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;		
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:mapView];
		
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}		
	
	return draggablePinView;
}

-(void) save:(id) sender {
	if (self.location == nil) {
		// - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, 
		UIAlertView* alerView = [[UIAlertView alloc] initWithTitle:nil message:@"还没有确认位置，请手动(长按地图)或GPS自动确认位置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alerView show];
		[alerView release];
		return;
	}
	
	if ([delegate respondsToSelector:@selector(onsave:)]) {
		[delegate onsave:self.location];
	}
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void) followLocation {
	NSString* description = [ModalAlert ask:@"您将收听此地，请输入这个地方的名字或描述" withTextPrompt:@"如:学校、超市、银科大厦等"];
	if (description == nil) {
		// does nothing
		return;
	}
	
	if ([description length] > 20 || [description length] == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"描述不正确" message:@"描述的长度范围是1-20个字符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	} else {
		for (int i = 0; i < [description length]; i++) {
			unichar c = [description characterAtIndex:i];
			if (c == ' ') {
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"描述不正确" message:@"描述请不要带空格" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
		}
	}
	
	// upload the follow location
	NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
	UtilModel* utilModel = [UtilModel getInstance];
	[data setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
	[data setObject:[[UserModel getInstance] getToken] forKey:@"token"];
	NSString* thelocation = [NSString stringWithFormat:@"(%lf %lf)", self.location.coordinate.longitude, self.location.coordinate.latitude];
	[data setObject:thelocation forKey:@"location"];
	[data setObject:description forKey:@"description"];
	
	//NSLog(@"the data:%@", modificationData);
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/follow/upl" 
											  PostDictionary:data];
	
	
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self];
	[self.view addSubview:loadingView];
	[loadingView release];
	[data release];
}

-(void) confirmAddLocation:(id) sender {
	if (self.location == nil) {
		// - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, 
		UIAlertView* alerView = [[UIAlertView alloc] initWithTitle:nil message:@"还没有确认位置，请手动(长按地图)或GPS自动确认位置" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alerView show];
		[alerView release];
		return;
	}
	[self followLocation];
	
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data {
	if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"收听失败" message:@"可以尝试重新登录后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"收听成功" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	
	if ([delegate respondsToSelector:@selector(onaddfollow:)]) {
		[delegate onaddfollow:self.location];
	}
	
	[self.parentViewController dismissModalViewControllerAnimated:YES];
	
}

-(void) view:(KKNetworkLoadingView *) sender onFailedLoading:(NSError *) error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"收听失败" message:@"请检查网络或重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
-(NSString*) loadingMessageForView:(KKNetworkLoadingView *) sender {
	return @"添加收听";
}
-(NSString*) failedMessageForView:(KKNetworkLoadingView *) sender {
	return @"收听失败";
}

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		
		//坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
		//得到经纬度，指触摸区域
        CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
		
		CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
		self.location = newLocation;
		[newLocation release];
		[self setPinAt:self.location];
		
    }
}


@end
