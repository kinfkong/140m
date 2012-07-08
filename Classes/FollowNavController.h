//
//  FollowNavController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KKUserListView.h"
#import "KKLocationListView.h"
#import "KKLocationAdjustController.h"
#import "KKMapController.h"

@interface FollowNavController : UIViewController<KKUserListViewDelegate, KKLocationAdjustControllerDelegate, KKLocationListViewDelegate, 
	KKMapControllerDelegate> {
	KKUserListView* userListView;
	KKLocationListView* locationListView;
	UISegmentedControl *segmentedControl;
	BOOL userListViewRefreshed;
	BOOL locationListViewRefreshed;
}

@end
