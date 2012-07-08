//
//  KKUserListView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-13.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBaseListView.h"


@protocol KKUserListViewDelegate;


@interface KKUserListView : KKBaseListView <KKBaseListViewDelegate> {
	id<KKUserListViewDelegate> userListdelegate;
}

@property(retain, nonatomic) id<KKUserListViewDelegate> userListdelegate;


@end

@protocol KKUserListViewDelegate <NSObject>

@optional
-(void) userList:(KKUserListView*) userList didTouchAt:(NSIndexPath *) indexPath;
-(NSString*) userList:(KKUserListView*) userList modifyDescriptionLabelText:(NSString *) description;

@end

