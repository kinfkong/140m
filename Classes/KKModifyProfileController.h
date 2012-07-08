//
//  KKModifyProfileController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-30.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKModifyProfileController : UIViewController <UITableViewDelegate, UITableViewDataSource, 
	UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate> {
	UITableView* tableView;
	NSMutableDictionary* userInfo;
	UISegmentedControl* segmentedControl;
	UIImageView* maleTick;
	UIImageView* femaleTick;
	UIImageView* headImageView;
		UIBarButtonItem* saveItem;
		NSMutableDictionary* modificationData;
		UITextField* nickTextField;
		UITextView* descriptionView;
		UITextField* oldpasswordField;
		UITextField* newpasswordField1;
		UITextField* newpasswordField2;
}

@property(nonatomic, retain) NSMutableDictionary* userInfo;

@end
