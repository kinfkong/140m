//
//  KKLocationManager.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-6.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKLocationManager.h"


@implementation KKLocationManager 


// override this method for mocking
-(void)startUpdatingLocation {
	  [NSThread detachNewThreadSelector:@selector(runUpdate) toTarget:self  withObject:nil];
}

-(void) runUpdate
{
    NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
	for (int i = 0; i < 1000; i++) {
		[NSThread sleepForTimeInterval:5];
	    CLLocation* newLocation = [[CLLocation alloc] initWithLatitude:38.9f longitude:116.3f];
		CLLocation* fromLocation = nil;
		NSDictionary* locationInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								  @"update", @"type",
								  self, @"manager",
								  newLocation, @"newLocation",
								  fromLocation, @"fromLocation",
								  nil];
		[(NSObject *) self.delegate performSelectorOnMainThread:@selector(updateLocation:) withObject:locationInfo  waitUntilDone:YES];
		[newLocation release];
	}
    [p release];
}


@end
