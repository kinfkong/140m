//
//  KKLocationAdjustController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-3.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@protocol KKLocationAdjustControllerDelegate;



@interface KKLocationAdjustController : UIViewController <MKMapViewDelegate> {
	CLLocation* location;
	MKMapView* mapView;
	UIActivityIndicatorView* activityIndicator;
	id<KKLocationAdjustControllerDelegate> delegate;
	BOOL addLocation;
}

@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, retain) 	id<KKLocationAdjustControllerDelegate> delegate;

-(id) initWithLocation:(CLLocation*) _location;
-(id) initWithAddLocationStyle;

-(void) setPinAt:(CLLocation *) _location;
@end


@protocol KKLocationAdjustControllerDelegate <NSObject>

@optional
-(void) oncancel:(CLLocation *) location;
-(void) onsave:(CLLocation *) location;
-(void) onaddfollow:(CLLocation *) location;

@end


