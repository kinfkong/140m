//
//  KKFieldModifyBaseController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-31.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKFieldModifyBaseController : UIViewController {
	id savetarget;
	SEL action;
	UIBarButtonItem* doneItem;
}

@property (nonatomic, retain) id savetarget;

-(id) initWithSaveTarget:(id) _target action:(SEL) _action;

@end


