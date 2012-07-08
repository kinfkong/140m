//
//  MainTabController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainTabController : UIViewController <UITabBarControllerDelegate, UINavigationControllerDelegate> {
	UITabBarController* barController;
}

@end
