//
//  KKMsgBoxStore.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgBoxStore.h"
#import "UserModel.h"

@interface KKMsgBoxStore (private)
-(void) save;
@end

@implementation KKMsgBoxStore

-(id) init {
	self = [super init];
	if (self != nil) {

		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		if ([paths count] > 0) {
			NSString* fileName = [NSString stringWithFormat:@"%@.msgbox", [[UserModel getInstance] getUserName]];
			saveFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
			[saveFile retain];
		}
		msgArray = [[NSMutableArray alloc] init];
		
		//NSLog(@"the file:%@", saveFile);
		
		// begin debug ... 
		/*
		msgArray = [[NSMutableArray alloc] init];
		NSMutableDictionary* msg1 = [[NSMutableDictionary alloc] init];
		[msg1 setObject:@"1" forKey:@"msgboxId"];
		[msg1 setObject:@"kk is testing..." forKey:@"msg"];
		[msg1 setObject:@"120" forKey:@"lng"];
		[msg1 setObject:@"38" forKey:@"lat"];
		
		NSMutableDictionary* msg2 = [[NSMutableDictionary alloc] init];
		[msg2 setObject:@"2" forKey:@"msgboxId"];
		[msg2 setObject:@"lalalala" forKey:@"msg"];
		
		NSMutableDictionary* msg3 = [[NSMutableDictionary alloc] init];
		[msg3 setObject:@"3" forKey:@"msgboxId"];
		[msg3 setObject:@"3lalalala" forKey:@"msg"];
		UIImage* image = [UIImage imageNamed:@"msgbox.png"];
		NSData* imageData = UIImageJPEGRepresentation(image, 1.0);
		[msg3 setObject:imageData forKey:@"image"];
		
		[msgArray addObject:msg1];
		[msgArray addObject:msg2];
		[msgArray addObject:msg3];
		[msg1 release];
		[msg2 release];
		[msg3 release];
		[self save];
		// end debug
		 */
		
		if (saveFile != nil) {
			NSMutableArray *arrayFromFile = [NSMutableArray arrayWithContentsOfFile:saveFile];
			if (arrayFromFile != nil) {
				[msgArray release];
				msgArray = [arrayFromFile retain];
			}
		}
		
	}
	return self;
}

-(void) dealloc {
	[msgArray release];
	[saveFile release];
	[super dealloc];
}

-(void) deleteMsg:(NSString *) msgId {
	while (TRUE) {
		BOOL found = NO;
		for (int i = 0; i < [msgArray count]; i++) {
			NSDictionary* info = [self getMsg:i];
			if ([[info objectForKey:@"msgboxId"] isEqualToString:msgId]) {
				[msgArray removeObjectAtIndex:i];
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

-(void) addMsg:(NSDictionary *) msgData {
	NSString* msgboxId = [msgData objectForKey:@"msgboxId"];
	
	BOOL found = NO;
	for (int i = 0; i < [msgArray count]; i++) {
		NSDictionary* info = [self getMsg:i];
		if ([[info objectForKey:@"msgboxId"] isEqualToString:msgboxId]) {
			[msgArray replaceObjectAtIndex:i withObject:msgData];
			found = YES;
		}
	}
	if (!found) {
		[msgArray addObject:msgData];
		//NSLog(@"after add:%d, %@", [msgArray count], msgData);
	}
	[self save];
}

-(int) getMsgNum {
	return [msgArray count];
}

-(NSDictionary*) getMsg:(int) index {
	return [msgArray objectAtIndex:index];
}


-(void) save {
	if (saveFile != nil) {
		[msgArray writeToFile:saveFile atomically:YES];
	}
}

@end
