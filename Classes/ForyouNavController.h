//
//  ForyouNavController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMsgListView.h"

@interface ForyouNavController : UIViewController <KKMsgListDelegate> {
	KKMsgListView* privateMsgListView;
	KKMsgListView* atmeMsgListView;
	BOOL privateMsgListViewRefreshed;
	BOOL atmeMsgListViewRefreshed;
	UISegmentedControl* segmentedControl;
}

@end
