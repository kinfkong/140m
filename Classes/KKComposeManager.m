//
//  KKComposeManager.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKComposeManager.h"
#import "KKMsgModel.h"
#import "KKMsgBoxStore.h"

@implementation KKComposeManager

@synthesize statusBarView;

static KKComposeManager* instance = nil;

-(id) init {
	self = [super init];
	if (self != nil) {
		sendingCount = 0;
		statusBarView = [[KKStatusBarView alloc] initWithFrame:CGRectMake(0, 43, 320, 20)];
	}
	return self;
}

-(void) dealloc {
	[statusBarView release];
	[super dealloc];
}

+(KKComposeManager *) getInstance {
	if (instance == nil) {
		instance = [[KKComposeManager alloc] init];
	}
	return instance;
}


-(void) sendComposedMsg:(NSDictionary *) msg {
	[msg retain];
	sendingCount++;
	if (sendingCount > 1) {
		[statusBarView showWithMsg:[NSString stringWithFormat:@"正在发送(%d)...", sendingCount]];
	} else {
		[statusBarView showWithMsg:@"正在发送 ..."];
	}	
	[NSThread detachNewThreadSelector:@selector(sendMsgViaNetwork:) toTarget:self withObject:msg];
	//[msg release];
}

-(void) finishedSendingWithError:(NSDictionary *) response {
	sendingCount--;
	if (sendingCount < 0) {
		sendingCount = 0;
	}
	NSNumber* error = (NSNumber *) [response objectForKey:@"error"];
	NSString* msgboxId = [response objectForKey:@"msgboxId"];
	if ([error intValue] == 0) {
		[statusBarView changeStatus:@"发送成功，且获取积分50!"];
		KKMsgBoxStore* store = [[KKMsgBoxStore alloc] init];
		[store deleteMsg:msgboxId];
		[store release];
	} else {
		// [statusBarView changeStatus:@"发送失败"];
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"发送失败" message:@"原内容已经保存到草稿箱" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	if (sendingCount > 1) {
		[statusBarView performSelector:@selector(changeStatus:) withObject:[NSString stringWithFormat:@"正在发送(%d)...", sendingCount]
							afterDelay:1];
	} else if(sendingCount > 0) {
		[statusBarView performSelector:@selector(changeStatus:) withObject:@"正在发送 ..."
							afterDelay:1];
	} else {
		[statusBarView disappear];
	}
}

-(void) sendMsgViaNetwork:(NSDictionary *) msg {
	[msg retain];
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	BOOL isSuccess = [KKMsgModel sendMsg:msg];
	int error = 0;
	if (isSuccess) {
	   error = 0;
	} else {
		error = -1;
	}
	NSMutableDictionary* response = [[NSMutableDictionary alloc] init];
	[response setObject:[NSNumber numberWithInt:error] forKey:@"error"];
	[response setObject:[msg objectForKey:@"msgboxId"] forKey:@"msgboxId"];
	[self performSelectorOnMainThread:@selector(finishedSendingWithError:) withObject:response waitUntilDone:YES];
	[msg release];
	[pool release];
	 [response release];
}

@end
