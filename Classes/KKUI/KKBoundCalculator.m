//
//  KKBoundCalculator.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKBoundCalculator.h"
#import <MapKit/MapKit.h>

typedef struct _KKSegment {
	double minEnd;
	double maxEnd;
} KKSegment;

@implementation KKBoundCalculator


+(KKMultiBound) calcBounds:(CLLocationCoordinate2D) center radius:(double) radius {
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, radius * 2.0, radius * 2.0);
	
	double lngDelta = region.span.longitudeDelta;
	double latDelta = region.span.latitudeDelta;
	if (region.span.longitudeDelta > 360) {
		latDelta = 360;
	}
	
	double minLng = center.longitude - lngDelta / 2.0;
	double maxLng = center.longitude + lngDelta / 2.0;
	double minLat = center.latitude - latDelta / 2.0;
	double maxLat = center.latitude + latDelta / 2.0;
	
	KKSegment lngSegment[4];
	int lngSegmentNum = 0;
	if (minLng < -180.0) {
		KKSegment segment1;
		KKSegment segment2;
		segment1.minEnd = 180 - (-180 - minLng);
		segment1.maxEnd = 180;
		segment2.minEnd = -180;
		segment2.maxEnd = maxLng;
		lngSegmentNum = 2;
		lngSegment[0] = segment1;
		lngSegment[1] = segment2;
	} else if (maxLng > 180.0) {
		KKSegment segment1;
		KKSegment segment2;
		segment1.minEnd = minLng;
		segment1.maxEnd = 180;
		segment2.minEnd = -180;
		segment2.maxEnd = -180 + (maxLng - 180);
		lngSegmentNum = 2;
		lngSegment[0] = segment1;
		lngSegment[1] = segment2;
	} else {
		KKSegment segment1;
		segment1.minEnd = minLng;
		segment1.maxEnd = maxLng;
		lngSegmentNum = 1;
		lngSegment[0] = segment1;
	}
	
	KKSegment latSegment;
	if (minLat < -90) {
		latSegment.minEnd = -90;
		double l1 = maxLat;
		double l2 = -minLat - 180;
		latSegment.maxEnd = l1 > l2 ? l1 : l2;
	} else if (maxLat > 90) {
		latSegment.maxEnd = 90;
		double l1 = minLat;
		double l2 = 90 - (maxLat - 90);
		latSegment.minEnd = l1 < l2 ? l1 : l2;
	} else {
		latSegment.minEnd = minLat;
		latSegment.maxEnd = maxLat;
	}
	
	KKMultiBound ans;
	ans.boundNum = 0;
	for (int i = 0; i < lngSegmentNum; i++) {
		KKBound bound;
		bound.minLat = latSegment.minEnd;
		bound.maxLat = latSegment.maxEnd;
		bound.minLng = lngSegment[i].minEnd;
		bound.maxLng = lngSegment[i].maxEnd;
		ans.bounds[ans.boundNum++] = bound;
	}
	return ans;
}

+(KKBound) calcBound:(CLLocationCoordinate2D) center radius:(double) radius {
	KKMultiBound bounds = [self calcBounds:center radius:radius];
	KKBound ans;
	memset(&ans, 0x00, sizeof(ans));
	double maxDelta = -1.0;
	for (int i = 0; i < bounds.boundNum; i++) {
		double delta = bounds.bounds[i].maxLng - bounds.bounds[i].minLng;
		delta = fabs(delta);
		if (delta > maxDelta) {
			ans = bounds.bounds[i];
			maxDelta = delta;
		}
	}
	return ans;
}
@end
