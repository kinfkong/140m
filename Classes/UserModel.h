//
//  UserModel.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "obananaViewController.h"
#import "KKNetworkLoadingView.h"


@interface UserModel : NSObject <KKNetworkLoadingViewDelegate> {
	BOOL loginFlag;
	obananaViewController* controller;
	NSDictionary* currentUserInfo;
	NSString* saveFile;
}

@property(nonatomic, retain) obananaViewController* controller;
@property(nonatomic, retain) NSDictionary* currentUserInfo;

+(UserModel *) getInstance;

-(BOOL) hasLogin;
-(BOOL) loginWithAccount:(NSString*) account password:(NSString *) password;

-(BOOL) loginWithUserName:(NSString*) userName token:(NSString *) token;
-(NSString*) getNickName;
-(NSString*) getUserName;
-(NSString*) getToken;
-(void) clearCurrentUser;
-(NSDictionary *) getUserInfo;
-(BOOL) logout;

-(void) setCurrentUser:(NSString *)name;

-(void) saveUserInfo:(NSDictionary *) userInfo;
@end
