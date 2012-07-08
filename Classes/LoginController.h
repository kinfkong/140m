//
//  LoginController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableViewCell* accountCell;
	IBOutlet UITableViewCell* passwordCell;
	IBOutlet UITableView* tableView;
	IBOutlet UITextField* accountTextField;
}

-(IBAction) registerAccount:(id) sender;


@property (nonatomic, retain) IBOutlet UITableViewCell* accountCell;
@property (nonatomic, retain) IBOutlet UITableViewCell* passwordCell;
@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, retain) IBOutlet UITextField* accountTextField;

@end
