//
//  KKLocationListView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-14.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBaseListView.h"

@protocol KKLocationListViewDelegate;

@interface KKLocationListView : KKBaseListView <KKBaseListViewDelegate> {
	id <KKLocationListViewDelegate> locationListDelegate;
}

@property(nonatomic, retain) id <KKLocationListViewDelegate> locationListDelegate;

@end

@protocol KKLocationListViewDelegate <NSObject>

@optional
-(void) locationList:(KKLocationListView*) locationList didTouchAt:(NSIndexPath *) indexPath;

@end

