//
//  KKLocationManagerDelegate.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-7.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol KKLocationManagerDelegate <CLLocationManagerDelegate>

-(void) updateLocation:(NSDictionary *) locationInfo;

@end
