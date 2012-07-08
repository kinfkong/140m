//
//  KKLoginController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-27.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterController.h"

@interface KKLoginController : UIViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate, RegisterControllerDelegate> {
	UITableView* tableView;
	UITextField* accountField;
	UITextField* passwordField;
	
	UIButton* loginButton;
	UIButton* registerButton;
	
	UILabel* passwordFieldTipLabel;
		UILabel* accountFieldTipLabel;
	CGFloat offsetHeight;
}
@property(assign) CGFloat offsetHeight;

-(void) loginWithName:(NSString *) name andToken:(NSString*) token;

@end
