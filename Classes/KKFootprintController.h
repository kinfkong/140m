//
//  KKFootprintController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-19.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKFootprintController : UIViewController {
	NSString* userName;
}

@property (nonatomic, retain) NSString* userName;
-(id) initWithUserName:(NSString *) _userName;
@end
