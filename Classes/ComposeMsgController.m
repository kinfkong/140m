    //
//  ComposeMsgController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-5.
//  Copyright 2011 tencent. All rights reserved.
//

#import "ComposeMsgController.h"
#import "ImageAttachmentViewController.h"
#import "KKLocationManager.h"
#import "KKComposeManager.h"
#import "KKLocationAdjustController.h"
#import "UIImage+Resize.h"
#import "KKBoundCalculator.h"
#import "KKFootprintModel.h"
#import "KKMsgBoxStore.h"
#import "UserModel.h"
#import "KKTweetParser.h"
#import "stdlib.h"
#import "time.h"


@interface ComposeMsgController (private)
-(BOOL) checkValidMsg:(NSDictionary *) data;
@end


@implementation ComposeMsgController


@synthesize showCharLeftLabel;
@synthesize mainTextView;
@synthesize distributeButton;
@synthesize imageAttachmentButton;
@synthesize cameraButton;
@synthesize imageAttachment;
@synthesize locationInfo;
@synthesize locationInfoButton;
@synthesize locationManager;
@synthesize toUser;
@synthesize replyData;
@synthesize msgboxData;
@synthesize initMsg;

-(id) initWithInitMsg:(NSString *) _initMsg {
	self = [self init];
	if (self != nil) {
		self.initMsg = _initMsg;
	}
	return self;
}
-(id) init {
	self = [super init];
	if (self != nil) {
		composeType = KKComposeTypeNormal;
		showMsgBox = YES;
	}
	return self;
}
-(id) initWithReplyData:(NSDictionary *) data {
	self = [super init];
	if (self != nil) {
		// replyId = [[data objectForKey:@"id"] longLongValue];
		composeType = KKComposeTypeReply;
		self.replyData = data;
		showMsgBox = YES;
	}
	return self;
}

-(id) initWithMsgBox:(NSDictionary *) _msgboxData {
	self = [super init];
	if (self != nil) {
		// replyId = [[data objectForKey:@"id"] longLongValue];
		composeType = KKComposeTypeMsgBox;
		self.msgboxData = _msgboxData;
		showMsgBox = NO;
	}
	return self;
}

-(id) initWithPrivateMail:(NSDictionary *) _toUser {
	self = [super init];
	if (self != nil) {
		composeType = KKComposeTypePrivate;
		self.toUser = _toUser;
		showMsgBox = YES;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	locationInfo = nil;
	[mainTextView becomeFirstResponder];
	[imageAttachmentButton setHidden:YES];
	//imageAttachmentButton.imageView.image = nil;
	imageAttachment = nil;
	
	//[self.locationManager startUpdatingLocation];
	
	mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
	//[self.view addSubview:mapView];
	mapView.showsUserLocation = YES;
	mapView.delegate = self;
	
	radius = 140.0;
	
	if (composeType == KKComposeTypeNormal && initMsg != nil) {
		mainTextView.text = initMsg;
		NSRange range;
		range.location = [initMsg length];
		range.length  = 0;
		mainTextView.selectedRange = range;
		[self textViewDidChange:mainTextView];
	}
	
	if (composeType == KKComposeTypeMsgBox) {
		mainTextView.text = [msgboxData objectForKey:@"msg"];
		NSData* imageData = [msgboxData objectForKey:@"image"];
		if (imageData != nil) {
			UIImage* image = [UIImage imageWithData:imageData];
			if (image != nil) {
				[self addImageAttachement:image];
			}
		}
		
		NSString* lng = [msgboxData objectForKey:@"lng"];
		NSString* lat = [msgboxData objectForKey:@"lat"];
		if (lng != nil && lat != nil) {
			double longitude = [lng doubleValue];
			double latitude = [lat doubleValue];
			CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
			if (location != nil) {
				mapView.showsUserLocation = NO;
				[self addLocationInfo:location];
			}
			[location release];
		}
		NSString* replyStr = [msgboxData objectForKey:@"replyId"];
		if (replyStr != nil) {
			replyId = [replyStr longLongValue];
		}
		
		NSRange range;
		range.location = 0;
		range.length  = 0;
		mainTextView.selectedRange = range;
		[self textViewDidChange:mainTextView];
		
		composeType = KKComposeTypeNormal;
		if ([msgboxData objectForKey:@"toUser"] != nil) {
			self.toUser = [msgboxData objectForKey:@"toUser"];
			composeType = KKComposeTypePrivate;
		}
	}
	
	if (composeType == KKComposeTypePrivate) {
		UINavigationBar* bar = (UINavigationBar *) [self.view viewWithTag:1231];
		bar.topItem.title = [NSString stringWithFormat:@"写信给%@", [self.toUser objectForKey:@"user_nick"]];
	} else if (KKComposeTypeReply == composeType && replyData != nil) {
		UINavigationBar* bar = (UINavigationBar *) [self.view viewWithTag:1231];
		bar.topItem.title = @"回复";
		replyId = [[self.replyData objectForKey:@"id"] longLongValue];
		NSDictionary* replyMsg = [self.replyData objectForKey:@"reply_msg"];
		NSString* deepReplyId = nil;
		if (replyMsg != nil) {
			deepReplyId = [replyMsg objectForKey:@"id"];
		}
		if (replyMsg != nil && deepReplyId != nil) {
			replyId = [deepReplyId longLongValue];
			NSString* replyText = [KKTweetParser display:[self.replyData objectForKey:@"msg"] withDisplayType:KKTweetDisplayEditType];
			replyText = [NSString stringWithFormat:@" || @%@:%@", [self.replyData objectForKey:@"user_name"], replyText];
			mainTextView.text = replyText;
			
			NSRange range;
			range.location = 0;
			range.length  = 0;
			mainTextView.selectedRange = range;
			[self textViewDidChange:mainTextView];
		}
	}
	
	if (replyId != 0) {
		[cameraButton setEnabled:NO];
	}

}

-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[mainTextView becomeFirstResponder];
}
-(IBAction)dismiss:(id)sender {
	if (showMsgBox && ((mainTextView.text != nil && ![mainTextView.text isEqualToString:@""]) || imageAttachment != nil)) { 
		msgBoxMenu = [[UIActionSheet alloc] initWithTitle:@"保存到草稿箱吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", @"不保存", nil];
		[msgBoxMenu showInView:self.view];
		//[msgBoxMenu release];
		return;
	}
	
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}



- (void)textViewDidChange:(UITextView *)textView {
	int left = 140 - mainTextView.text.length;
	self.showCharLeftLabel.text = [NSString stringWithFormat:@"%d", left];
	if (left >= 0) {
		self.showCharLeftLabel.textColor = [UIColor lightGrayColor];
		distributeButton.enabled = TRUE;
	} else {
		self.showCharLeftLabel.textColor = [UIColor redColor];
		distributeButton.enabled = FALSE;
	}
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
    // [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[toUser release];
	[mapView release];
	[iavc release];
	[replyData release];
	[msgboxData release];
	[pickImageMenu release];
	[msgBoxMenu release];
	[initMsg release];
    [super dealloc];
}


-(IBAction) showImagePickupMenu:(id) sender {
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
		ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		ipc.delegate = self;
		ipc.allowsEditing = NO;
		[self presentModalViewController:ipc animated:YES];
		[ipc release];
	} else {
		pickImageMenu = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片库", @"拍照", nil];
		[pickImageMenu showInView:self.view];
	}
}

-(void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
	if (actionSheet == pickImageMenu) {
		if (buttonIndex == 0) {
			UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
			ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			ipc.delegate = self;
			ipc.allowsEditing = NO;
			[self presentModalViewController:ipc animated:YES];
			[ipc release];
		} else if (buttonIndex == 1) {
			UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
			ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
			ipc.delegate = self;
			ipc.allowsEditing = NO;
			[self presentModalViewController:ipc animated:YES];
			[ipc release];
		} else {
	
		}
	} else if (actionSheet == msgBoxMenu) {
		if (buttonIndex == 0) {
			NSDictionary* data = [self getSerializeData];
			KKMsgBoxStore* store = [[KKMsgBoxStore alloc] init];
			[store addMsg:data];
			[store release];
			//NSLog(@"here!!:%d", [store getMsgNum]);
			[self.parentViewController dismissModalViewControllerAnimated:YES];
		} else if (buttonIndex == 1) {
			[self.parentViewController dismissModalViewControllerAnimated:YES];
		}
	}
}

-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
	[self dismissModalViewControllerAnimated:YES];
	UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	float width = image.size.width;
	float height = image.size.height;
	float ratio = 1;
	if (width > height && width > 800) {
		ratio = 800.0 / width;
	} else if (height > width && height > 800) {
		ratio = 800.0 / height;
	}
	width *= ratio;
	height *= ratio;
	
	image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
	// UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	// [self performSelectorOnMainThread:@selector(addImageAttachement:) withObject:image waitUntilDone:YES];
	[self addImageAttachement:image];
	
	//[ipc release];
}


-(void) addImageAttachement:(UIImage *) image {
	// UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
	self.imageAttachment = image;
	[imageAttachmentButton setHidden:NO];
	[cameraButton setEnabled:NO];
	//imageAttachmentButton.imageView.image = imageAttachment;
	imageAttachmentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
	[imageAttachmentButton setImage:image forState:UIControlStateNormal];	
}


-(void) removeImageAttachement {
	imageAttachment = nil;
	[imageAttachmentButton setHidden:YES];
	[cameraButton setEnabled:YES];
	// [imageAttachmentButton setImage:imageAttachment forState:UIControlStateNormal];	
}


-(IBAction) showImageDetail:(id) sender {
	iavc = [[ImageAttachmentViewController alloc] init];
	iavc.image = self.imageAttachment;
	[self presentModalViewController:iavc animated:YES];
}

-(IBAction) showLocationAdjust:(id) sender {
	KKLocationAdjustController* controller = [[KKLocationAdjustController alloc] initWithLocation:self.locationInfo];
	controller.delegate = self;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

-(IBAction) sendMsg:(id) sender {
	NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:16];
	if (mainTextView.text != nil) {
		[data setObject:mainTextView.text forKey:@"msg"];
	}
	
	if (imageAttachment != nil) {
		[data setObject:imageAttachment forKey:@"image"];
	}
	
	if (locationInfo != nil) {
		[data setObject:locationInfo forKey:@"location"];
		
		KKBound bound = [KKBoundCalculator calcBound:locationInfo.coordinate radius:radius];
		NSString* polygon = [NSString stringWithFormat:@"(%lf %lf, %lf %lf, %lf %lf, %lf %lf, %lf %lf)", 
							 bound.minLng, bound.minLat, bound.minLng, bound.maxLat, bound.maxLng, bound.maxLat, bound.maxLng, bound.minLat, 
							 bound.minLng, bound.minLat];
		
		// NSLog(@"The polygon:%@", polygon);
		[data setObject:polygon forKey:@"bound"];
		
			[[KKFootprintModel getInstance] sendFootprint:locationInfo];
		
	}
	
	if (composeType == KKComposeTypePrivate) {
		[data setObject:[self.toUser objectForKey:@"user_name"] forKey:@"to_user"];
		[data setObject:@"1" forKey:@"type"];
	}
	
	//replyId = 1;
	if (replyId != 0) {
		[data setObject:[NSString stringWithFormat:@"%llu", replyId] forKey:@"reply"];
	}
	
	if (![self checkValidMsg:data]) {
		return;
	}
	
	NSDictionary* msgboxInfo = [self getSerializeData];
	KKMsgBoxStore* store = [[KKMsgBoxStore alloc] init];
	[store addMsg:msgboxInfo];
	[store release];
	
	[data setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
	[data setObject:[[UserModel getInstance] getToken] forKey:@"token"];
	[data setObject:[msgboxInfo objectForKey:@"msgboxId"] forKey:@"msgboxId"];
	
	// [msgModel sendMsg:data];
	[[KKComposeManager getInstance] sendComposedMsg:data];
	
	// backup to the msg box

	// send the footprint

	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


-(BOOL) checkValidMsg:(NSDictionary *) data {
	if (data == nil) {
		return NO;
	}
	UIImage* image = [data objectForKey:@"image"];
	NSString* msg = [data objectForKey:@"msg"];
	if ((msg == nil || [msg length] == 0) && image == nil && replyId == 0) {
		// - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"请输入文字或上传照片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	}
	
	CLLocation* location = [data objectForKey:@"location"];
	if (location == nil) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"还没确定您所在的位置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"手动设置位置", nil];
		[alert show];
		[alert release];
		return NO;
	}
	return YES;
}

-(void) addLocationInfo:(CLLocation *) newLocation {

	
	if (self.locationInfo == nil) {
		UIImage* locationOKImage = [UIImage imageNamed:@"GPSIconOK.png"];
		[locationInfoButton setImage:locationOKImage forState:UIControlStateNormal];	
	}

	self.locationInfo = newLocation;
}

-(void) locationManager:(CLLocationManager *) manager
	   didFailWithError:(NSError *) error {
	NSLog(@"Location manager error: %@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	//NSLog(@"the new location: %@", newLocation);
	// [self addLocationInfo:newLocation];
}

-(void) updateLocation:(NSDictionary *) locationInfo1 {
	NSString* type = [locationInfo1 objectForKey:@"type"];
	CLLocationManager* manager = [locationInfo1 objectForKey:@"manager"];
	if ([type isEqualToString:@"update"]) {
		CLLocation* newLocation = [locationInfo1 objectForKey:@"newLocation"];
		CLLocation* fromLocation = [locationInfo1 objectForKey:@"fromLocation"];
		[self locationManager:manager didUpdateToLocation:newLocation fromLocation:fromLocation];
	}
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
	CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
	[self addLocationInfo:newLocation];
	[newLocation release];
}

-(void) oncancel:(CLLocation *) location {
	
}
-(void) onsave:(CLLocation *) location {
	if (location != nil) {
		mapView.showsUserLocation = NO;
		[self addLocationInfo:location];
	}
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//NSLog(@"the index to click:%d", buttonIndex);
	if (buttonIndex == 1) {
		[self showLocationAdjust:self];
		return;
	}
}

-(NSDictionary *) getSerializeData {
	NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
	[data setObject:mainTextView.text forKey:@"msg"];
	if (self.locationInfo != nil) {
		//NSString* locationStr = [NSString stringWithFormat:@"(%.5lf %.5lf)", self.locationInfo.coordinate.longitude, self.locationInfo.coordinate.latitude];
		[data setObject:[NSString stringWithFormat:@"%.5lf", self.locationInfo.coordinate.longitude] forKey:@"lng"];
		[data setObject:[NSString stringWithFormat:@"%.5lf", self.locationInfo.coordinate.latitude] forKey:@"lat"];
	}
	
	if (self.imageAttachment != nil) {
		NSData* imageData = UIImageJPEGRepresentation(imageAttachment, 1.0);
		if (imageData != nil) {
			[data setObject:imageData forKey:@"image"];
		}
	}
	
	if (replyId != 0) {
		[data setObject:[NSString stringWithFormat:@"%lld", replyId] forKey:@"replyId"];
	}
	if (self.toUser != nil) {
		[data setObject:self.toUser forKey:@"toUser"];
	}
	if (self.msgboxData != nil) {
		[data setObject:[self.msgboxData objectForKey:@"msgboxId"] forKey:@"msgboxId"];
	} else {
		srandom(time(NULL));
		NSString* msgboxId = [NSString stringWithFormat:@"%ld_%ld_%ld", random(), random(), random()]; 
		[data setObject:msgboxId forKey:@"msgboxId"];
	}
	return [data autorelease];
}

@end
