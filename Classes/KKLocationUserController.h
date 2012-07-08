//
//  KKLocationUserController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-10.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKUserListView.h"
#import <MapKit/MapKit.h>

@interface KKLocationUserController : UIViewController <KKUserListViewDelegate> {
	KKUserListView* userListView;
	CLLocationCoordinate2D theLocation;
}
-(id) initWithLocation:(CLLocationCoordinate2D) location;
@property(nonatomic, retain) KKUserListView* userListView;

@end
