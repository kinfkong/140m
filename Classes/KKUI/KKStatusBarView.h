//
//  KKStatusBarView.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKStatusBarView : UIView {
	UILabel* label;
}

@property(nonatomic, retain) UILabel* label;

-(void) showWithMsg:(NSString*) msg;
-(void) changeStatus:(NSString *) msg;
-(void) disappear;

@end
