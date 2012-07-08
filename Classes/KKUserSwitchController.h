//
//  KKUserSwitchController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-25.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKUserStore.h"

@interface KKUserSwitchController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	KKUserStore* userStore;
	UITableView* tableView;
	UIBarButtonItem *editItem;
	UIBarButtonItem *finishedItem; 
}

@end
