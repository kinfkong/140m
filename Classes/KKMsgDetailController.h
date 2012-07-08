//
//  KKMsgDetailController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-27.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMsgListView.h"


@interface KKMsgDetailController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	UIWebView* webView;
	NSDictionary* data;
	KKMsgListView* msgListView;
}

@property(nonatomic, retain) NSDictionary* data;
@property(nonatomic, retain) KKMsgListView* msgListView;

-(id) initWithMsg:(NSDictionary *) msg;

@end
