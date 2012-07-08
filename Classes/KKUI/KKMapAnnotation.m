//
//  KKMapAnnotation.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-3.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMapAnnotation.h"


@implementation KKMapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize delegate;

-(id) initWithCoordinate:(CLLocationCoordinate2D) aCoordinate {
	self = [super init];
	if (self != nil) {
		coordinate = aCoordinate;
	}
	return self;
}

-(void) dealloc {
	[title release];
	[subtitle release];
	[delegate release];
	[super dealloc];
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	if ([delegate respondsToSelector:@selector(setCoordinate:)]) {
		[delegate setCoordinate:newCoordinate];
	}
	self.coordinate = newCoordinate;
}

@end
