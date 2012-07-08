//
//  KKDefaultMsgController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMsgListView.h"


@interface KKDefaultMsgController : UIViewController <KKMsgListDelegate>{
	KKMsgListView* msgListView;
	NSString* url;
}

-(id) initWithMsgURL:(NSString *)_url;

@property(nonatomic, retain) KKMsgListView* msgListView;
@property(nonatomic, retain) NSString* url;

@end
