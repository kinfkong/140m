//
//  KKComposeManager.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKStatusBarView.h"

@interface KKComposeManager : NSObject {
	int sendingCount;
	KKStatusBarView* statusBarView;
}

@property(nonatomic, retain) KKStatusBarView* statusBarView;

+(KKComposeManager *) getInstance;

-(void) sendComposedMsg:(NSDictionary *) msg;

@end
