//
//  UserModel.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "UserModel.h"
#import "KKNetworkLoadingView.h"
#import "UtilModel.h"
#import "KKUserStore.h"

@implementation UserModel

@synthesize controller;
@synthesize currentUserInfo;

static UserModel* instance = nil;

-(id) init {
	loginFlag = NO;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	if ([paths count] > 0) {
		saveFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"currentUserInfo"];
		[saveFile retain];
	}
	
	if (saveFile != nil) {
		NSMutableDictionary *dictFromFile = [NSMutableDictionary dictionaryWithContentsOfFile:saveFile];
		if (dictFromFile != nil) {
			[currentUserInfo release];
			currentUserInfo = [dictFromFile retain];
		}
	}
	return self;
}

+(UserModel *) getInstance {
	if (instance == nil) {
		instance = [[UserModel alloc] init];
	}
	return instance;
}

-(void) clearCurrentUser {
	self.currentUserInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
	// save
	if (saveFile != nil) {
		[currentUserInfo writeToFile:saveFile atomically:YES];
	}
}

-(BOOL) hasLogin {
	// TODO:
	return (currentUserInfo != nil) && ([currentUserInfo objectForKey:@"user_name"] != nil);
	// return loginFlag;
}

-(NSString *) getUserName {
	// TODO:
	return [currentUserInfo objectForKey:@"user_name"];
}

-(NSString*) getNickName {
	// TODO:
	return [currentUserInfo objectForKey:@"user_nick"];
}

-(NSDictionary *) getUserInfo {
	return currentUserInfo;
}

-(NSString*) getToken {
	// TODO:
	return [currentUserInfo objectForKey:@"token"];
}
-(void) setCurrentUser:(NSString *)name {
	// TODO:
	loginFlag = YES;
}

-(BOOL) loginWithAccount:(NSString*) account password:(NSString *) password {
	// show the logining label
	UtilModel* utilModel = [UtilModel getInstance];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:account, @"account", password, @"password", nil];
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/user/login" 
											  PostDictionary:dict];
	
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self];
	//NSLog(@"the view:%@", self.controller.view);

	[self.controller.view addSubview:loadingView];
	[loadingView release];
	
	return YES;
}

-(BOOL) logout {
	KKUserStore* userStore = [[KKUserStore alloc] init];
	[userStore deleteUser:[currentUserInfo objectForKey:@"user_name"]];
	[userStore release];
	[self clearCurrentUser];
	[self.controller viewReload];
	return YES;
}

-(BOOL) loginWithUserName:(NSString*) userName token:(NSString *) token {
	UtilModel* utilModel = [UtilModel getInstance];
	NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"user_name", token, @"token", nil];
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/user/logintoken" 
											  PostDictionary:dict];
	
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self];
	//NSLog(@"the view:%@", self.controller.view);
	[self.controller.view addSubview:loadingView];
	[loadingView release];
	
	return YES;
}


-(void) dealloc {
	[controller release];
	[currentUserInfo release];
	[saveFile release];
	[super dealloc];
}


-(void) saveUserInfo:(NSDictionary *) userInfo {
	//NSLog(@"the user info:%@", userInfo);
	self.currentUserInfo = userInfo;
	if (saveFile != nil) {
		[currentUserInfo writeToFile:saveFile atomically:YES];
	}
	
	KKUserStore* userStore = [[KKUserStore alloc] init];
	[userStore addUser:userInfo];
	[userStore release];
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data {
	//NSLog(@"finished switch: the data:%@", data);
	if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
		// - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"帐号或密码不正确" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[self saveUserInfo:[data objectForKey:@"detail"]];

	[self.controller performSelectorOnMainThread:@selector(viewReload) withObject:nil waitUntilDone:YES];
	//[self.controller viewReload];
}

-(void) view:(KKNetworkLoadingView *) sender onFailedLoading:(NSError *) error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请检查网络" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
-(NSString*) loadingMessageForView:(KKNetworkLoadingView*) sender {
	return @"正在登录";
}
-(NSString*) failedMessageForView:(KKNetworkLoadingView*) sender {
	return @"登录失败";
}

@end
