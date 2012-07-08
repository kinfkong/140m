//
//  KKBoundCalculator.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef struct _KKBound {
	double minLng;
	double maxLng;
	double minLat;
	double maxLat;
} KKBound;

typedef struct _KKMultiBound {
	KKBound bounds[4];
	int boundNum;
} KKMultiBound;

@interface KKBoundCalculator : NSObject {

}

+(KKMultiBound) calcBounds:(CLLocationCoordinate2D) center radius:(double) radius;

+(KKBound) calcBound:(CLLocationCoordinate2D) center radius:(double) radius;

@end
