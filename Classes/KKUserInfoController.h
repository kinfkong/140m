//
//  KKUserInfoController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-4.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKNetworkLoadingView.h"


@interface KKUserInfoController : UIViewController <KKNetworkLoadingViewDelegate, UITableViewDataSource, UITableViewDelegate> {
	NSDictionary* userInfo;
	NSDictionary* fullUserInfo;
	UIBarButtonItem* editItem;
}

@property(nonatomic, retain) NSDictionary* userInfo;
@property(nonatomic, retain) NSDictionary* fullUserInfo;

-(id) initWithUserName:(NSString *) _userName;
-(id) initWithUserInfo:(NSDictionary *) _userInfo;

@end
