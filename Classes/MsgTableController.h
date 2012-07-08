//
//  MsgTableController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeMsgController.h"
#import "KKMsgListView.h"

@interface MsgTableController : UIViewController <KKMsgListDelegate> {
	KKMsgListView* msgListView;
}

@property(nonatomic, retain) KKMsgListView* msgListView;

-(IBAction) showDetail;

@end
