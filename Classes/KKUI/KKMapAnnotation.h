//
//  KKMapAnnotation.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-3.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol KKMapAnnotationDelegate;


@interface KKMapAnnotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	NSString* title;
	NSString* subtitle;
	id<KKMapAnnotationDelegate> delegate;
}

@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, retain) NSString* title;
@property(nonatomic, retain) NSString* subtitle;
@property(nonatomic, retain) id<KKMapAnnotationDelegate> delegate;

@end

@protocol KKMapAnnotationDelegate <NSObject>
@optional
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
