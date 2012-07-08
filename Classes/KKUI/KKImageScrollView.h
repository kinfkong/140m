//
//  KKImageScrollView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-1.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+ASYNC.h"

@interface KKImageScrollView : UIView <UIImageViewAsyncDelegate,UIScrollViewDelegate> {
	UIActivityIndicatorView* activityIndicator;
	UIImageView* imageView;
	UIScrollView* scrollView;
}

- (id)initWithFrame:(CGRect)frame imageId:(NSString*) imageId;

@end
