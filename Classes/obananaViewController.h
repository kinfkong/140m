//
//  obananaViewController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface obananaViewController : UIViewController {
	UIViewController* controller;
}

@property(nonatomic, retain) UIViewController* controller;
-(void) viewReload;

@end

