//
//  KKMsgBoxController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMsgBoxStore.h"


@interface KKMsgBoxController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	KKMsgBoxStore* msgStore;
	UITableView* tableView;
	UIBarButtonItem *editItem;
	UIBarButtonItem *finishedItem; 
}

@end
