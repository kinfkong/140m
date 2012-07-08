//
//  KKIconPageView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKIconPageView : UIView <UIScrollViewDelegate> {
	UIScrollView* scrollView;
	UIPageControl* pageControl;
	BOOL pageControlUsed;
}

-(id) initWithFrame:(CGRect) frame iconList:(NSArray *) list;
-(void)changePage:(id)sender;
@end
