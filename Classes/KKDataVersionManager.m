//
//  KKDataVersionManager.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-31.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKDataVersionManager.h"



@implementation KKDataVersionManager

static KKDataVersionManager* instance = nil;

@synthesize versionDict;

-(id) init {
	self = [super init];
	if (self != nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			saveFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"dataversion"];
			[saveFile retain];
		}
		
		self.versionDict = [[NSMutableDictionary alloc] init];
		if (saveFile != nil) {
			NSMutableDictionary *dictFromFile = [NSMutableDictionary dictionaryWithContentsOfFile:saveFile];
			if (dictFromFile != nil) {
				self.versionDict = dictFromFile;
			}
		}
		
		if ([versionDict objectForKey:@"version"] == nil) {
			[versionDict setObject:@"1" forKey:@"version"];
		}
	}
	return self;
}

+(KKDataVersionManager *) getInstance {
	if (instance == nil) {
		instance = [[KKDataVersionManager alloc] init];
	}
	return instance;
}

-(void) increaseDataVersion {
	NSString* version = [versionDict objectForKey:@"version"];
	version = [NSString stringWithFormat:@"%d", [version intValue] + 1];
	[self.versionDict setObject:version forKey:@"version"];
	[self saveVersion];
}

-(BOOL) shouldUpdate:(NSString*) key {
	NSString* version1 = [versionDict objectForKey:@"version"];
	NSString* version2 = [versionDict objectForKey:key];
	NSLog(@"the versions:dict:%@, %@, %@", versionDict, version1, version2);
	return ![version1 isEqualToString:version2];
}

-(void) updated:(NSString*) key {
	NSString* version = [versionDict objectForKey:@"version"];
	[self.versionDict setObject:version forKey:key];
	[self saveVersion];
}

-(void) dealloc {
	[versionDict release];
	[saveFile release];
	[super dealloc];
}

-(void) saveVersion {
	if (saveFile != nil) {
		[versionDict writeToFile:saveFile atomically:YES];
	}
}

@end
