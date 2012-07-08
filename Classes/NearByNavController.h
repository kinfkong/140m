//
//  NearByNavController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ComposeMsgController.h"
#import "KKMsgListView.h"
#import "KKLocationAdjustController.h"
#import <MapKit/MapKit.h>
#import "KKUserListView.h"

@interface NearByNavController : UIViewController <KKMsgListDelegate, KKLocationAdjustControllerDelegate, MKMapViewDelegate, 
	UINavigationControllerDelegate, KKUserListViewDelegate, UIAccelerometerDelegate> {
	KKMsgListView* msgListView;
	CLLocation* location;
	MKMapView* mapView;
	NSDate* lastSelectDate;
		KKUserListView* userListView;
		KKUserListView* followListView;
		BOOL msgListViewRefresh;
		BOOL userListViewRefresh;
		BOOL followListViewRefresh;
		UISegmentedControl* segmentedControl;
        UIAcceleration* lastAcceleration;
        BOOL histeresisExcited;

}

@property(nonatomic, retain) KKMsgListView* msgListView;
@property(nonatomic, retain) KKUserListView* userListView;
@property(nonatomic, retain) KKUserListView* followListView;
@property(nonatomic, retain) CLLocation* location;
@property(nonatomic, retain) NSDate* lastSelectDate;
@property(nonatomic, retain) UISegmentedControl* segmentedControl;
@property(nonatomic, retain) UIAcceleration* lastAcceleration;

-(IBAction) showDetail;

-(void) findLocation;

-(void) didSelected;
@end
