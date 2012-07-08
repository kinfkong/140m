//
//  KKPageControl.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-25.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol KKPageControlDelegate;

@interface KKPageControl : UIView 
{
@private
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    UIColor *dotColorCurrentPage;
    UIColor *dotColorOtherPage;
    NSObject<KKPageControlDelegate> *delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, assign) NSObject<KKPageControlDelegate> *delegate;

@end

@protocol KKPageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(KKPageControl *)pageControl;
@end
