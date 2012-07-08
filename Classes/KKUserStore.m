//
//  KKUserStore.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-25.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKUserStore.h"

@interface KKUserStore (private)
-(void) save;
@end

@implementation KKUserStore


-(id) init {
	self = [super init];
	if (self != nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			saveFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"userlists"];
			[saveFile retain];
		}
		
		userArray = [[NSMutableArray alloc] init];
		
		if (saveFile != nil) {
			NSMutableArray *arrayFromFile = [NSMutableArray arrayWithContentsOfFile:saveFile];
			if (arrayFromFile != nil) {
				[userArray release];
				userArray = [arrayFromFile retain];
			}
		}
		
		
		/*
		NSMutableDictionary* user1 = [[NSMutableDictionary alloc] init];
		[user1 setObject:@"kkwang" forKey:@"user_name"];
		[user1 setObject:@"王景刚" forKey:@"user_nick"];
		[user1 setObject:@"12345678" forKey:@"password"];
		[user1 setObject:@"1" forKey:@"head_image_id"];
		
		
		NSMutableDictionary* user2 = [[NSMutableDictionary alloc] init];
		[user2 setObject:@"test1" forKey:@"user_name"];
		[user2 setObject:@"测试1" forKey:@"user_nick"];
		[user2 setObject:@"12345678" forKey:@"password"];
				[user2 setObject:@"1" forKey:@"head_image_id"];
		
		NSMutableDictionary* user3 = [[NSMutableDictionary alloc] init];
		[user3 setObject:@"obanana" forKey:@"user_name"];
		[user3 setObject:@"橙蕉科技" forKey:@"user_nick"];
		[user3 setObject:@"12345678" forKey:@"password"];
				[user3 setObject:@"1" forKey:@"head_image_id"];
		
		[userArray addObject:user1];
		[userArray addObject:user2];
		[userArray addObject:user3];
		[user1 release];
		[user2 release];
		[user3 release];
		 */
	}
	return self;
}

-(void) deleteUser:(NSString *) userName {
	NSLog(@"The userName:%@", userName);
	while (TRUE) {
		BOOL found = NO;
	for (int i = 0; i < [userArray count]; i++) {
		NSDictionary* info = [self getUser:i];
		NSLog(@"the info:%@, userName:%@", info, userName);
		if ([[info objectForKey:@"user_name"] isEqualToString:userName]) {
			[userArray removeObjectAtIndex:i];
			
			found = YES;
			break;
		}
	}
		if (!found) {
			break;
		}
	}
	[self save];
}

-(void) addUser:(NSDictionary *) userInfo {
	NSString* name = [userInfo objectForKey:@"user_name"];
	BOOL found = NO;
	for (int i = 0; i < [userArray count]; i++) {
		NSDictionary* info = [self getUser:i];
		if ([[info objectForKey:@"user_name"] isEqualToString:name]) {
			[userArray replaceObjectAtIndex:i withObject:userInfo];
			found = YES;
		}
	}
	if (!found) {
		[userArray addObject:userInfo];
	}
	[self save];
}

-(int) getUserNum {
	return [userArray count];
}

-(NSDictionary*) getUser:(int) index {
	return (NSDictionary *) [userArray objectAtIndex:index];
}

-(void) dealloc {
	[userArray release];
	[saveFile release];
	[super dealloc];
}
-(void) save {
	if (saveFile != nil) {
		[userArray writeToFile:saveFile atomically:YES];
	}
}
@end
