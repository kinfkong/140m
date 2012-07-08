//
//  KKDefaultLocationController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-12.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKLocationListView.h"


@interface KKDefaultLocationController : UIViewController <KKLocationListViewDelegate> {
	KKLocationListView* locationListView;
	NSString* url;
}
@property(nonatomic, retain) KKLocationListView* locationListView;
@property(nonatomic, retain) NSString* url;

-(id) initWithLocationURL:(NSString *) _url;

@end
