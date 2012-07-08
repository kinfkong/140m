//
//  KKMsgListCellView.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ASYNC.h"

@class KKMsgListReplyView;

@protocol KKMsgListCellViewDelegate;

@interface KKMsgListCellView : UITableViewCell {
	UIImageView* imageView;
	UIImageView* authorImageView;
	UILabel*     authorNameLabel;
	UILabel*     timeLabel;
	UILabel*     msgLabel;
	UILabel*     comeFromLabel;
	UILabel*     fromLocationLabel;
	UILabel*     replyNumLabel;
	KKMsgListReplyView* replyView;
	NSIndexPath* currentIndexPath;
	id<KKMsgListCellViewDelegate> delegate;
	BOOL replyHidden;
}

@property(nonatomic, retain) NSIndexPath* currentIndexPath;
@property(nonatomic, retain) id<KKMsgListCellViewDelegate> delegate;
@property(assign) BOOL replyHidden;

//+(CGFloat) cellHeight:(NSDictionary *) data tableView:(UITableView *) tableView;
+(CGFloat) cellHeight:(NSDictionary *) data tableView: (UITableView *) tableView showReply:(BOOL) showReply;

-(void) setData: (NSDictionary *) data atIndexPath:(NSIndexPath *) indexPath imageDelegate:(id<UIImageViewAsyncDelegate>) delegate;

@end

@interface KKMsgListReplyView : UIView {
	UILabel* msgLabel;
	UIImageView* imageView;
}

+(CGFloat) viewHeight:(NSDictionary *) data;

-(void) setData: (NSDictionary *) data atIndexPath:(NSIndexPath *) indexPath imageDelegate:(id<UIImageViewAsyncDelegate>) delegate;

@end



@protocol KKMsgListCellViewDelegate <NSObject>
@optional

-(void) onAuthorImageViewClicked:(NSIndexPath *) indexPath;

@end