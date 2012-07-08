//
//  KKLocationMessageController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-10.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMsgListView.h"
#import <MapKit/MapKit.h>

@interface KKLocationMessageController : UIViewController <KKMsgListDelegate> {
	KKMsgListView* msgListView;
	CLLocationCoordinate2D theLocation;
}

-(id) initWithLocation:(CLLocationCoordinate2D) location;

@property(nonatomic, retain) KKMsgListView* msgListView;

@end
