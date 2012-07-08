//
//  KKMsgListView.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-23.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "KKMoreTableFooterView.h"
#import "KKMsgStore.h"
#import "UIImageView+ASYNC.h"
#import "KKMsgListCellView.h"
#import "GADBannerView.h"

@protocol KKMsgListDelegate;

@interface KKMsgListView : UIView <GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, KKMoreTableFooterDelegate, UIImageViewAsyncDelegate, KKMsgListCellViewDelegate> {
	UITableView* tableView;
	EGORefreshTableHeaderView* _refreshHeaderView;
	KKMoreTableFooterView* footerView;
	BOOL _reloading;
	id<KKMsgListDelegate> delegate;
	KKMsgStore* msgStore;
	NSCondition* updateLock;
	BOOL replyHidden;
	GADBannerView* adBanner;
	BOOL showBanner;
}

@property(nonatomic, retain) id<KKMsgListDelegate> delegate;
@property(assign) BOOL replyHidden;

- (id)initWithFrame:(CGRect)frame initWithUpdateURL:(NSString *)url andIdentifier:(NSString *) identifier controller:(UIViewController *) controller;
- (id)initWithFrame:(CGRect)frame initWithUpdateURL:(NSString *)url andIdentifier:(NSString *) identifier;

-(NSDictionary *) getMsgDataAt:(NSIndexPath *) indexPath;

-(void) cleanAll;

-(void) refresh;

-(void) setURL:(NSString *) url;

-(NSInteger) getMsgNum;


@end

@protocol KKMsgListDelegate <NSObject>

@optional
-(void) msgListView:(KKMsgListView *) listView didLongTouchAt:(NSIndexPath *) indexPath;
-(void) msgListView:(KKMsgListView *) listView didTouchAt:(NSIndexPath *) indexPath;
-(void) msgListView:(KKMsgListView *) listView didAuthorImageViewClicked:(NSIndexPath *) indexPath;

@end


