    //
//  KKMapController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "ModalAlert.h"
#import "KKMapController.h"
#import <CoreLocation/CoreLocation.h>
#import "UserModel.h"
#import "UtilModel.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import <QuartzCore/QuartzCore.h>
#import "KKLocationMessageController.h"
#import "KKLocationUserController.h"

enum KKMapButtonLoadingViewType {
	KKMapButtonLoadingViewFollowLocation = 56787,
	KKMapButtonLoadingViewCancelFollow,
	KKMapButtonLoadingViewUpdate,
};

@interface MKLocationManager 
- (CLLocation*)_applyChinaLocationShift:(CLLocation*)arg; 
- (BOOL)chinaShiftEnabled; 
+ (id)sharedLocationManager; 
@end




@implementation KKMapController

@synthesize editable;
@synthesize description;
@synthesize isUnFollow;
@synthesize followId;
@synthesize delegate;

-(id) initWithLocation2D:(CLLocationCoordinate2D) location {
	self = [super init];
	if (self != nil) {
		centerLocation = location;
		editable = NO;
		isEditing = NO;
		isUnFollow = NO;
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
	self.title = @"查看地图";
	self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	mapView = [[MKMapView alloc] initWithFrame:frame];
	mapView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.view addSubview:mapView];
	mapView.delegate = self;
	
	
	/*if ([[MKLocationManager sharedLocationManager] chinaShiftEnabled]) { 
		CLLocation* location = [[CLLocation alloc] initWithLatitude:centerLocation.latitude longitude:centerLocation.longitude];
		CLLocation* newlocation = [[MKLocationManager sharedLocationManager] _applyChinaLocationShift:location];
		if (newlocation == nil) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"shift failed." message:[NSString stringWithFormat:@"%@,%@", [MKLocationManager sharedLocationManager], location] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
			[alert show];
		}
		centerLocation = newlocation.coordinate;
	}*/
	
	mapView.region = MKCoordinateRegionMakeWithDistance(centerLocation, 3000.0f, 3000.0f);
	KKMapAnnotation* anAnnotation = [[[KKMapAnnotation alloc] initWithCoordinate:centerLocation] autorelease];
	[mapView addAnnotation:anAnnotation];
	//mapView.showsUserLocation = YES;
	mapView.zoomEnabled = YES;
	//[mapView release];
	
	// add add location controll
	if (isUnFollow) {
	UIButton* followLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[followLocationButton setImage:[UIImage imageNamed:@"nolisten_icon.png"] forState:UIControlStateNormal];
	[followLocationButton addTarget:self action:@selector(unfollowLocation) forControlEvents:UIControlEventTouchUpInside];
	followLocationButton.alpha = 0.6;
	followLocationButton.frame = CGRectMake(320 - 50, mapView.frame.origin.y + 40, 40, 40);
	followLocationButton.layer.masksToBounds = YES;
	followLocationButton.layer.cornerRadius = 4.0;
	followLocationButton.layer.borderWidth = 0.0;
	followLocationButton.layer.borderColor = [[UIColor clearColor] CGColor];
	[self.view addSubview:followLocationButton];
	} else {
		UIButton* followLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[followLocationButton setImage:[UIImage imageNamed:@"listen_icon.png"] forState:UIControlStateNormal];
		[followLocationButton addTarget:self action:@selector(followLocation) forControlEvents:UIControlEventTouchUpInside];
		followLocationButton.alpha = 0.6;
		followLocationButton.frame = CGRectMake(320 - 50, mapView.frame.origin.y + 40, 40, 40);
		followLocationButton.layer.masksToBounds = YES;
		followLocationButton.layer.cornerRadius = 4.0;
		followLocationButton.layer.borderWidth = 0.0;
		followLocationButton.layer.borderColor = [[UIColor clearColor] CGColor];
		[self.view addSubview:followLocationButton];
	}
	
	UIButton* nearByMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nearByMessageButton setImage:[UIImage imageNamed:@"nearby_message_icon.png"] forState:UIControlStateNormal];
	[nearByMessageButton addTarget:self action:@selector(showNearbyMessage) forControlEvents:UIControlEventTouchUpInside];
	nearByMessageButton.alpha = 0.6;
	nearByMessageButton.frame = CGRectMake(320 - 50, mapView.frame.origin.y + 100, 40, 40);
	nearByMessageButton.layer.masksToBounds = YES;
	nearByMessageButton.layer.cornerRadius = 4.0;
	nearByMessageButton.layer.borderWidth = 0.0;
	nearByMessageButton.layer.borderColor = [[UIColor clearColor] CGColor];
	[self.view addSubview:nearByMessageButton];
	
	UIButton* nearByUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[nearByUserButton setImage:[UIImage imageNamed:@"nearby_user_icon.png"] forState:UIControlStateNormal];
	[nearByUserButton addTarget:self action:@selector(showNearbyUser) forControlEvents:UIControlEventTouchUpInside];
	nearByUserButton.alpha = 0.6;
	nearByUserButton.frame = CGRectMake(320 - 50, mapView.frame.origin.y + 160, 40, 40);
	nearByUserButton.layer.masksToBounds = YES;
	nearByUserButton.layer.cornerRadius = 4.0;
	nearByUserButton.layer.borderWidth = 0.0;
	nearByUserButton.layer.borderColor = [[UIColor clearColor] CGColor];
	[self.view addSubview:nearByUserButton];
	
	if (editable) {
		//UITabBarItem* item = [UITabBarItem 
		editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(changeToEditMode)];
		self.navigationItem.rightBarButtonItem = editItem;
		
		finishedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneModification)];
		// self.navigationItem.rightBarButtonItem = editItem;
		
		CGFloat width = 200;
		CGFloat height = 25;
		UITextField* descriptionField = [[UITextField alloc] initWithFrame:CGRectMake((320 - width) / 2, mapView.frame.origin.y + 15, width, height)];
		descriptionField.text = self.description;
		descriptionField.textAlignment = UITextAlignmentCenter;
		descriptionField.backgroundColor = [UIColor whiteColor];
		descriptionField.returnKeyType = UIReturnKeyDone;
		//descriptionField.alpha = 0.8;
		descriptionField.tag = 13478;
		[descriptionField addTarget:self action:@selector(unfocusTextField:) forControlEvents:UIControlEventEditingDidEndOnExit];
		[self.view addSubview:descriptionField];
		[descriptionField release];
		descriptionField.hidden = YES;
	}
	
	UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    lpress.minimumPressDuration = 0.5;//按0.5秒响应longPress方法
    lpress.allowableMovement = 10.0;
	//map 为mkmapview的实例
    [mapView addGestureRecognizer:lpress];
    [lpress release];    
	
}

-(void) unfocusTextField:(id) sender {
	//NSLog(@"here!!!");
	UITextField* textField = (UITextField *) sender;
	[textField resignFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//NSLog(@"trigger here!!:%d,%d", buttonIndex, alertView.tag);
	if (buttonIndex == 1 && alertView.tag == 111111) {
		if (self.followId == nil) {
			return;
		}
		UtilModel* utilModel = [UtilModel getInstance];
		NSMutableDictionary* modificationData = [[NSMutableDictionary alloc] init];
		[modificationData setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
		[modificationData setObject:[[UserModel getInstance] getToken] forKey:@"token"];
		//NSLog(@"the data:%@", modificationData);
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/unfollowlocation/%@", self.followId];
		NSURLRequest* request = [utilModel generateRequesWithURL:url 
												  PostDictionary:modificationData];
		KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self tag:KKMapButtonLoadingViewCancelFollow];
		//loadingView.tag = KKMapButtonLoadingViewCancelFollow;
		[self.view addSubview:loadingView];
		[loadingView release];
		[modificationData release];
	}
}

-(void) unfollowLocation {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"真的要取消收听这个地方?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	alert.tag = 111111;
	[alert show];
	[alert release];
}

-(void) followLocation {
	NSString* _description = [ModalAlert ask:@"您将收听此地，请输入这个地方的名字或描述" withTextPrompt:@"如:学校、超市、银科大厦等"];
		if (_description == nil) {
			// does nothing
			return;
		}
	
	
		if ([_description length] > 20 || [_description length] == 0) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"描述不正确" message:@"描述的长度范围是1-20个字符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		} else {
			for (int i = 0; i < [_description length]; i++) {
				unichar c = [_description characterAtIndex:i];
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
	NSString* location = [NSString stringWithFormat:@"(%lf %lf)", centerLocation.longitude, centerLocation.latitude];
	[data setObject:location forKey:@"location"];
	[data setObject:_description forKey:@"description"];
	
	//NSLog(@"the data:%@", modificationData);
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/follow/upl" 
											  PostDictionary:data];
	
	
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self tag:KKMapButtonLoadingViewFollowLocation];
	[self.view addSubview:loadingView];
	[loadingView release];
	[data release];
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
	[editItem release];
	[finishedItem release];
	[mapView release];
	[description release];
	[followId release];
	[delegate release];
    [super dealloc];
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data {
	if (sender.tag == KKMapButtonLoadingViewFollowLocation) {
		if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"收听失败" message:@"可以尝试重新登录后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"收听成功" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (sender.tag == KKMapButtonLoadingViewCancelFollow) {
		if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"取消收听失败" message:@"可以尝试重新登录后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		if (self.navigationController.topViewController == self) {
			[self.navigationController popViewControllerAnimated:YES];
		}
		if (self.delegate != nil && [self.delegate respondsToSelector:@selector(map:onFinishedModification:)]) {
			[delegate map:self onFinishedModification:nil];
		}
	} else if (sender.tag == KKMapButtonLoadingViewUpdate) {
		if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"可以尝试重新登录后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		} else {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"成功保存" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			if (self.navigationController.topViewController == self) {
				[self.navigationController popViewControllerAnimated:YES];
			}
			if (self.delegate != nil && [self.delegate respondsToSelector:@selector(map:onFinishedModification:)]) {
				[delegate map:self onFinishedModification:nil];
			}
			return;
		}
		

	}
}

-(void) view:(KKNetworkLoadingView *) sender onFailedLoading:(NSError *) error {
	if (sender.tag == KKMapButtonLoadingViewFollowLocation) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"收听失败" message:@"请检查网络或重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (sender.tag == KKMapButtonLoadingViewCancelFollow) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"取消收听失败" message:@"请检查网络或重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else if (sender.tag == KKMapButtonLoadingViewUpdate) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"请检查网络或重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
	} 
}

-(NSString*) loadingMessageForView:(KKNetworkLoadingView *) sender {
	NSLog(@"the tag:%d", sender.tag);
	if (sender.tag == KKMapButtonLoadingViewFollowLocation) {
		return @"添加收听";
	} else if (sender.tag == KKMapButtonLoadingViewCancelFollow) {
		//	NSLog(@"here2");
		return @"取消收听";
	} else if (sender.tag == KKMapButtonLoadingViewUpdate) {
		return @"正在保存";
	}
	return @"";
}
-(NSString*) failedMessageForView:(KKNetworkLoadingView *) sender {
	if (sender.tag == KKMapButtonLoadingViewFollowLocation) {
		return @"收听失败";
	} else if (sender.tag == KKMapButtonLoadingViewCancelFollow) {
		return @"取消收听失败";
	} else if (sender.tag == KKMapButtonLoadingViewUpdate) {
		return @"保存失败";
	}
	return @"";
}

-(void) changeToEditMode {
	isEditing = YES;
	self.navigationItem.rightBarButtonItem = finishedItem;
	UITextField* descriptionField = (UITextField*) [self.view viewWithTag:13478];
	descriptionField.hidden = NO;
	//[descriptionField resignFirstResponder];
	[self setPinAt:centerLocation];
}

-(void) doneModification {
	UITextField* descriptionField = (UITextField*) [self.view viewWithTag:13478];
		NSString* _description = descriptionField.text;
		
		if (_description == nil || [_description length] > 20 || [_description length] == 0) {
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"描述不正确" message:@"描述的长度范围是1-20个字符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		} else {
			for (int i = 0; i < [_description length]; i++) {
				unichar c = [_description characterAtIndex:i];
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
	[data setObject:self.followId forKey:@"follow_id"];
		NSString* thelocation = [NSString stringWithFormat:@"(%lf %lf)", centerLocation.longitude, centerLocation.latitude];
		[data setObject:thelocation forKey:@"location"];
		[data setObject:_description forKey:@"description"];
		
		//NSLog(@"the data:%@", modificationData);
		NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/follow/locationupdate/" 
												  PostDictionary:data];
		
		
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self tag:KKMapButtonLoadingViewUpdate];
		[self.view addSubview:loadingView];
		[loadingView release];
		[data release];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	/*UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"当前位置by mapView" message:[NSString stringWithFormat:@"%@", userLocation.location] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
	CLLocationCoordinate2D current;
	current = userLocation.location.coordinate;
	KKMapAnnotation* anAnnotation = [[[KKMapAnnotation alloc] initWithCoordinate:current] autorelease];
	[mapView addAnnotation:anAnnotation];
	
	[alert show];
	 */
}

-(void) removeAllPins {
	NSMutableArray* toRemove = [[NSMutableArray alloc] init];
	for (id annotation in mapView.annotations) {
		if (YES /*[annotation isKindOfClass:[DDAnnotation class]] */) {
			//[mapView removeAnnotation:annotation];
			[toRemove addObject:annotation];
		}
	}
	for (id annotation in toRemove) {
		[mapView removeAnnotation:annotation];
	}
	[toRemove release];
}


-(void) setPinAt:(CLLocationCoordinate2D) _location {
	if (isEditing == NO) {
		return;
	}
	[self removeAllPins];
	DDAnnotation *annotation = [[[DDAnnotation alloc] initWithCoordinate:_location addressDictionary:nil] autorelease];
	annotation.title = @"拖动大头针可改变位置";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	[mapView addAnnotation:annotation];	
}


#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	if (isEditing == NO) {
		return;
	}
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	centerLocation = annotation.coordinate;
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	
	if (oldState == MKAnnotationViewDragStateDragging) {
		if (isEditing == NO) {
			return;
		}
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];	
		centerLocation = annotation.coordinate;
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

- (void)longPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		if (isEditing == NO) {
			return;
		}
		//坐标转换
        CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
		//得到经纬度，指触摸区域
        CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
		centerLocation = touchMapCoordinate;
		[self setPinAt:centerLocation];
		
    }
}

-(void) showNearbyMessage {
	KKLocationMessageController* controller = [[KKLocationMessageController alloc] initWithLocation:centerLocation];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) showNearbyUser {
	KKLocationUserController* controller = [[KKLocationUserController alloc] initWithLocation:centerLocation];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end
