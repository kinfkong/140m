//
//  KKUserProfileView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-4.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKUserProfileView : UIView {
	NSMutableDictionary* userInfo;
}

@property(nonatomic, retain) NSMutableDictionary* userInfo;

-(id) initWithUserInfo:(NSDictionary *) _userInfo andFrame:(CGRect) frame;

@end
