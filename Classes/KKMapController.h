//
//  KKMapController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "KKMapAnnotation.h"
#import "KKNetworkLoadingView.h"


@protocol KKMapControllerDelegate;


@interface KKMapController : UIViewController <MKMapViewDelegate,KKNetworkLoadingViewDelegate> {
	CLLocationCoordinate2D centerLocation;
	BOOL editable;
	UIBarButtonItem* editItem;
	UIBarButtonItem* finishedItem;
	MKMapView* mapView;
	BOOL isEditing;
	NSString* description;
	BOOL isUnFollow;
	NSString* followId;
	id<KKMapControllerDelegate> delegate;
}
@property(assign) BOOL editable;
@property(assign) BOOL isUnFollow;
@property(nonatomic, retain) NSString* description;
@property(nonatomic, retain) NSString* followId;
@property(nonatomic, retain) id<KKMapControllerDelegate> delegate;
-(id) initWithLocation2D:(CLLocationCoordinate2D) location;

-(void) setPinAt:(CLLocationCoordinate2D) _location;

@end


@protocol KKMapControllerDelegate <NSObject>

@optional
-(void) map:(KKMapController*) mapController onFinishedModification:(NSString*) info;

@end
