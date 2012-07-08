//
//  MoreNavController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPageControl.h"


@interface MoreNavController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate> {
	KKPageControl* pageControl;
	UIScrollView* scrollView;
	BOOL pageControlUsed;
}
-(void)changePage:(id)sender;
@end
