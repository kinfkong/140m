//
//  KKAllReplyController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-7.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMsgListView.h"


@interface KKAllReplyController : UIViewController <KKMsgListDelegate> {
	NSString* msgId;
	KKMsgListView* msgListView;
}

@property(nonatomic, retain) NSString* msgId;

-(id) initWithMsgId:(NSString *) msgId;

@end
