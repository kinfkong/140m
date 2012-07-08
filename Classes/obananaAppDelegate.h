//
//  obananaAppDelegate.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
// 

#import <UIKit/UIKit.h>

@class obananaViewController;

@interface obananaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    obananaViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet obananaViewController *viewController;

@end

