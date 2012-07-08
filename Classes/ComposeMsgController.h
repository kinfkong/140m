//
//  ComposeMsgController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-5.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CLLocationManager.h"
#import "CoreLocation/CLLocationManagerDelegate.h"

#import "ImageAttachmentViewController.h"

#import <MapKit/MapKit.h>
#import "KKLocationAdjustController.h"

typedef enum  {
	KKComposeTypeNormal,
	KKComposeTypeReply,
	KKComposeTypePrivate,
	KKComposeTypeMsgBox,
}KKComposeType;

@interface ComposeMsgController : UIViewController <UITextViewDelegate, 
UIImagePickerControllerDelegate, 
UINavigationControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate, KKLocationAdjustControllerDelegate, UIAlertViewDelegate> {
	IBOutlet UILabel* showCharLeftLabel;
	IBOutlet UITextView* mainTextView;
	IBOutlet UIBarButtonItem* distributeButton;
	IBOutlet UIButton* imageAttachmentButton;
	IBOutlet UIButton* cameraButton;
	IBOutlet UIButton* locationInfoButton;
	
	UIImage* imageAttachment;
	
	ImageAttachmentViewController * iavc;
	CLLocation* locationInfo;
	
	unsigned long long replyId;
	
	MKMapView* mapView;
	
	double radius;
	
	KKComposeType composeType;
	NSDictionary* toUser;
	NSDictionary* replyData;
	NSDictionary* msgboxData;
	NSString* initMsg;
	
	UIActionSheet* msgBoxMenu;
	UIActionSheet* pickImageMenu;
	BOOL showMsgBox;
}

-(id) initWithInitMsg:(NSString *) _initMsg;
-(id) initWithReplyData:(NSDictionary *) data;
-(id) initWithMsgBox:(NSDictionary *) _msgboxData;
-(id) initWithPrivateMail:(NSDictionary *) _toUser;

-(IBAction)dismiss:(id)sender;
-(void) addImageAttachement:(UIImage *) image;
-(void) addLocationInfo:(CLLocation *) newLocation;
-(IBAction) showImagePickupMenu:(id) sender;
-(IBAction) showImageDetail:(id) sender;
-(IBAction) sendMsg:(id) sender;

-(IBAction) showLocationAdjust:(id) sender;
-(NSDictionary *) getSerializeData;
-(void) removeImageAttachement;

@property (nonatomic, retain) IBOutlet UILabel* showCharLeftLabel;
@property (nonatomic, retain) IBOutlet UITextView* mainTextView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* distributeButton;
@property (nonatomic, retain) IBOutlet UIButton* imageAttachmentButton;
@property (nonatomic, retain) IBOutlet UIButton* locationInfoButton;
@property (nonatomic, retain) IBOutlet UIButton* cameraButton;
@property (nonatomic, retain) IBOutlet UIImage* imageAttachment;
@property (nonatomic, retain) CLLocation* locationInfo;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) NSDictionary* toUser;
@property (nonatomic, retain) NSDictionary* replyData;
@property (nonatomic, retain) NSDictionary* msgboxData;
@property (nonatomic, retain) NSString* initMsg;
@end
