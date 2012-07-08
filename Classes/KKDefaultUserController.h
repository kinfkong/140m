//
//  KKDefaultUserController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKUserListView.h"


@interface KKDefaultUserController : UIViewController <KKUserListViewDelegate> {
	KKUserListView* userListView;
	NSString* url;
}
-(id) initWithUserURL:(NSString*) _url;
@property(nonatomic, retain) KKUserListView* userListView;
@property(nonatomic, retain) NSString* url;

@end
