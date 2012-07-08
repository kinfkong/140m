    //
//  KKModifyProfileController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-30.
//  Copyright 2011 tencent. All rights reserved.
//
#import "UserModel.h"
#import "KKModifyProfileController.h"
#import "UIImageView+ASYNC.h"
#import "UIImage+Resize.h"
#import "UtilModel.h"
#import "KKNetworkLoadingView.h"
#import "KKDataVersionManager.h"
#import "KKFieldModifyBaseController.h"

@interface KKModifyProfileController (private)

-(void) showImagePickupMenu;
-(void) finishItem:(NSString *) itemName data:(id) data;


@end


@implementation KKModifyProfileController

@synthesize userInfo;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/
-(id) initWithUserInfo:(NSDictionary *) _userInfo {
	self = [super init];
	if (self != nil) {
		self.userInfo = [NSMutableDictionary dictionaryWithDictionary:_userInfo];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.title = @"修改资料";
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	
	saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveModification)];
	self.navigationItem.rightBarButtonItem = saveItem;
	saveItem.enabled = NO;
	
	modificationData = [[NSMutableDictionary alloc] init];
	/* 
	 self.userInfo = [[NSMutableDictionary alloc] init];
	[self.userInfo setObject:@"kkwang" forKey:@"user_name"];
	[self.userInfo setObject:@"王景刚" forKey:@"user_nick"];
	[self.userInfo setObject:@"1" forKey:@"head_image_id"];
	[self.userInfo setObject:@"male" forKey:@"gender"];
	[self.userInfo setObject:@"obanana创始人，140m唯一开发者，爱老婆，爱开发" forKey:@"description"];
	 */
	
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1) {
		return 2;
	} else if (section == 2) {
		return 2;
	}
	return 1;
}


-(CGFloat) tableView:(UITableView *) _tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 50;
}

- (UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = nil;
	if ([indexPath section] == 0) {
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profilecell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [self.userInfo objectForKey:@"head_image_id"]];
		
		NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										  [self.userInfo objectForKey:@"name"], @"id", indexPath, @"indexPath", nil];
		[cell.imageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:imageInfo];
		headImageView = [cell.imageView retain];
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		//cell.textLabel.textColor = [UIColor grayColor];
		cell.textLabel.text = @"      更换头像";
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if ([indexPath section] == 1 && [indexPath row] == 0) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"profilecell2"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		cell.textLabel.text = @"昵称:";
		cell.detailTextLabel.text = [self.userInfo objectForKey:@"nick"];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if ([indexPath section] == 1 && [indexPath row] == 1) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"profilecell2"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		cell.textLabel.text = @"简介:";
		 NSString* description = [self.userInfo objectForKey:@"description"];
		if (description == nil || [description isEqualToString:@""]) {
			cell.detailTextLabel.textColor = [UIColor grayColor];
			description = @"还没写简介...";
		}
		cell.detailTextLabel.text = description;
		cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if ([indexPath section] == 2 && [indexPath row] == 0) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"profilecell2"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.textLabel.font = [UIFont systemFontOfSize:16];
		 
		cell.textLabel.text = @" ";
		
		cell.detailTextLabel.text = @"修改密码";
		cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else if ([indexPath section] == 2 && [indexPath row] == 1) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profilecell2"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		CGFloat swidth = 180;
		CGFloat sheight = 25;
		NSArray *itemArray = [NSArray arrayWithObjects:@"男", @"女",nil];
		segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
		segmentedControl.frame = CGRectMake((320 - swidth) / 2, (50 - sheight) / 2, swidth, sheight);

		[cell addSubview:segmentedControl];
		
		[segmentedControl addTarget:self action:@selector(genderChanged) forControlEvents:UIControlEventValueChanged];
		
		maleTick = [[UIImageView alloc] initWithFrame:CGRectMake(segmentedControl.frame.origin.x + swidth / 4 + 10, segmentedControl.frame.origin.y + (sheight - 20) / 2, 20, 20)];
		maleTick.image = [UIImage imageNamed:@"tick-icon.png"];
				[cell addSubview:maleTick];


		maleTick.hidden = YES;
		
		femaleTick = [[UIImageView alloc] initWithFrame:CGRectMake(segmentedControl.frame.origin.x + 3 * swidth / 4 + 10, segmentedControl.frame.origin.y + (sheight - 20) / 2, 20, 20)];
		femaleTick.image = [UIImage imageNamed:@"tick-icon.png"];
		
		[cell addSubview:femaleTick];


		femaleTick.hidden = YES;
		if ([[userInfo objectForKey:@"gender"] isEqualToString:@"female"]) {
			segmentedControl.selectedSegmentIndex = 1;
		} else {
			segmentedControl.selectedSegmentIndex = 0;
		}
		
	} else {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"profilecell"];
	}
	return [cell autorelease];
}

-(void) genderChanged {
	NSString* gender = nil;
	if (segmentedControl.selectedSegmentIndex == 0) {
		maleTick.hidden = NO;
		femaleTick.hidden = YES;
		gender = @"male";
	} else {
		maleTick.hidden = YES;
		femaleTick.hidden = NO;
		gender = @"female";
	}
	if (![gender isEqualToString:[self.userInfo objectForKey:@"gender"]]) {
		[self finishItem:@"gender" data:gender];
	}
}

- (void)dealloc {
	[tableView release];
	[userInfo release];
	[segmentedControl release];
	[maleTick release];
	[femaleTick release];
	[headImageView release];
	[saveItem release];
	[modificationData release];
	[nickTextField release];
	[descriptionView release];
	[oldpasswordField release];
	[newpasswordField1 release];
	[newpasswordField2 release];
    [super dealloc];
}


-(void) showImagePickupMenu {
	if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
		ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		ipc.delegate = self;
		ipc.allowsEditing = YES;
		[self presentModalViewController:ipc animated:YES];
		[ipc release];
	} else {
		UIActionSheet* menu = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"图片库", @"拍照", nil];
		[menu showInView:self.view];
		[menu release];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return [NSString stringWithFormat:@"%@的个人资料", [[UserModel getInstance] getUserName]];
	}
	return nil;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] == 0) {
		[self showImagePickupMenu];
	} else if ([indexPath section] == 1 && [indexPath row] == 0) {
		KKFieldModifyBaseController* controller = [[KKFieldModifyBaseController alloc] initWithSaveTarget:self action:@selector(saveNick)];
		controller.title = @"修改昵称";
		CGFloat width = 280;
		CGFloat height = 30;
		nickTextField = [[UITextField alloc] initWithFrame:CGRectMake((320 - width) / 2, 20, width, height)];
		nickTextField.backgroundColor = [UIColor whiteColor];
		nickTextField.font = [UIFont systemFontOfSize:24];
		nickTextField.text = [self.userInfo objectForKey:@"nick"];
		// nickTextField.backgroundColor = [UIColor blackColor];
		[controller.view addSubview:nickTextField];
		
		[self.navigationController pushViewController:controller animated:YES];
		[nickTextField becomeFirstResponder];
		[controller release];
	} else if ([indexPath section] == 1 && [indexPath row] == 1) {
		KKFieldModifyBaseController* controller = [[KKFieldModifyBaseController alloc] initWithSaveTarget:self action:@selector(saveDescription)];
		controller.title = @"修改简介";
		CGFloat width = 320;
		CGFloat height = 160;
		descriptionView = [[UITextView alloc] initWithFrame:CGRectMake((320 - width) / 2, 0, width, height)];
		descriptionView.backgroundColor = [UIColor whiteColor];
		descriptionView.font = [UIFont systemFontOfSize:18];
		descriptionView.text = [self.userInfo objectForKey:@"description"];
		// nickTextField.backgroundColor = [UIColor blackColor];
		[controller.view addSubview:descriptionView];
		
		
		[self.navigationController pushViewController:controller animated:YES];
		[descriptionView becomeFirstResponder];
		[controller release];
	} else if ([indexPath section] == 2 && [indexPath row] == 0) {
		KKFieldModifyBaseController* controller = [[KKFieldModifyBaseController alloc] initWithSaveTarget:self action:@selector(savePassword)];
		controller.title = @"修改密码";
		CGFloat width = 230;
		CGFloat height = 24;
		oldpasswordField = [[UITextField  alloc] initWithFrame:CGRectMake(80, 10, width, height)];
		oldpasswordField.backgroundColor = [UIColor whiteColor];
		[controller.view addSubview:oldpasswordField];
		newpasswordField1 = [[UITextField  alloc] initWithFrame:CGRectMake(80, 44, width, height)];
		newpasswordField1.backgroundColor = [UIColor whiteColor];
		[controller.view addSubview:newpasswordField1];
		newpasswordField2 = [[UITextField  alloc] initWithFrame:CGRectMake(80, 78, width, height)];
		newpasswordField2.backgroundColor = [UIColor whiteColor];
		[controller.view addSubview:newpasswordField2];
		
		oldpasswordField.secureTextEntry = YES;
		newpasswordField1.secureTextEntry = YES;
		newpasswordField2.secureTextEntry = YES;
		
		
		UILabel* oldlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 75, height)];
		oldlabel.text = @"旧密码:";
		oldlabel.textColor = [UIColor blackColor];
		oldlabel.textAlignment = UITextAlignmentRight;
		oldlabel.backgroundColor = [UIColor clearColor];
		[controller.view addSubview:oldlabel];
		[oldlabel release];
		
		UILabel* newlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 75, height)];
		newlabel1.text = @"新密码:";
		newlabel1.textColor = [UIColor blackColor];
		newlabel1.textAlignment = UITextAlignmentRight;
		newlabel1.backgroundColor = [UIColor clearColor];
		[controller.view addSubview:newlabel1];
		[newlabel1 release];
		
		UILabel* newlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, 75, height)];
		newlabel2.text = @"确认密码:";
		newlabel2.textColor = [UIColor blackColor];
		newlabel2.textAlignment = UITextAlignmentRight;
		newlabel2.backgroundColor = [UIColor clearColor];
		[controller.view addSubview:newlabel2];
		[newlabel2 release];
		
		[self.navigationController pushViewController:controller animated:YES];
		[oldpasswordField becomeFirstResponder];
		[controller release];
	}
}

-(void) saveNick {
	NSString* newNick = nickTextField.text;
	if ([newNick length] > 20 || [newNick length] == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"昵称更改失败" message:@"昵称是1-12位中文、数字、字母、下划线或减号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	} else {
		for (int i = 0; i < [newNick length]; i++) {
			unichar c = [newNick characterAtIndex:i];
			if (c >= 128) {
				continue;
			}
			if (c >= 'a' && c <= 'z') {
				continue;
			}
			if (c >= 'A' && c <= 'Z') {
				continue;
			}
			if (c >= '0' && c <= '9') {
				continue;
			}
			if (c == '-' || c == '_') {
				continue;
			}
			UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"昵称更改失败" message:@"昵称是1-12位中文、数字、字母、下划线或减号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
	}
	[self.userInfo setObject:newNick forKey:@"nick"];
	[self.navigationController popViewControllerAnimated:YES];
	[tableView reloadData];
	[self finishItem:@"nick" data:newNick];
}

-(void) saveDescription {
	NSString* description = descriptionView.text;
	if ([description length] > 280) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"简介更改失败" message:@"简介最多280个字符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	[self.userInfo setObject:description forKey:@"description"];
	[self.navigationController popViewControllerAnimated:YES];
	[tableView reloadData];
	[self finishItem:@"description" data:description];
}

-(void) savePassword {
	NSString* oldpassword = oldpasswordField.text;
	NSString* newpassword1 = newpasswordField1.text;
	NSString* newpassword2 = newpasswordField2.text;
	if ([oldpassword length] == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入原密码" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	if (![newpassword1 isEqualToString:newpassword2]) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"两次输入的密码不一致，请重新输入" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	if ([newpassword1 length] < 6 || [newpassword1 length] > 16) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"更改失败" message:@"密码长度应为6-16个字符" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	[self.navigationController popViewControllerAnimated:YES];
	[self finishItem:@"oldpassword" data:oldpassword];
	[self finishItem:@"newpassword" data:newpassword1];
}

-(void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
	if (buttonIndex == 0) {
		UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
		ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		ipc.delegate = self;
		ipc.allowsEditing = YES;
		[self presentModalViewController:ipc animated:YES];
		[ipc release];
	} else if (buttonIndex == 1) {
		UIImagePickerController* ipc = [[UIImagePickerController alloc] init];
		ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
		ipc.delegate = self;
		ipc.allowsEditing = YES;
		[self presentModalViewController:ipc animated:YES];
		[ipc release];
	} else {
		
	}
}


-(void) imagePickerController:(UIImagePickerController *) picker didFinishPickingMediaWithInfo:(NSDictionary *) info {
	[self dismissModalViewControllerAnimated:YES];
	UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	float width = image.size.width;
	float height = image.size.height;
	float ratio = 1;
	
	if (width > height && width > 800) {
		ratio = 800 / width;
	} else if (height > width && height > 800) {
		ratio = 800 / height;
	}
	width *= ratio;
	height *= ratio;
	
	image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(width, height) interpolationQuality:kCGInterpolationHigh];
	headImageView.image = image;
	
	[self finishItem:@"head_image" data:image];
}

-(void) finishItem:(NSString *)itemName data:(id)data {
	saveItem.enabled = YES;
	[modificationData setObject:data forKey:itemName];
}

-(void) saveModification {
	UtilModel* utilModel = [UtilModel getInstance];
	[modificationData setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
	[modificationData setObject:[[UserModel getInstance] getToken] forKey:@"token"];
	//NSLog(@"the data:%@", modificationData);
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/user/updateprofile" 
											  PostDictionary:modificationData];
	
	saveItem.enabled = NO;
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self];
	[self.view addSubview:loadingView];
	[loadingView release];
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *) data {
	//NSLog(@"the data:%@", data);
	if ([[data objectForKey:@"errno"] isEqualToString:@"-2"]) {
		// - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<UIAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"旧密码不正确" message:@"如果要修改密码，请输入正确的旧密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	} else if (![[data objectForKey:@"errno"] isEqualToString:@"0"]) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"可以尝试重新登录后重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"上传成功" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[[UserModel getInstance] saveUserInfo:[data objectForKey:@"detail"]];
	[[KKDataVersionManager getInstance] increaseDataVersion];
	/*
	[self saveUserInfo:[data objectForKey:@"detail"]];
	
	[self.controller viewReload];
	 */
}

-(void) view:(KKNetworkLoadingView *) sender  onFailedLoading:(NSError *) error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"上传失败" message:@"请检查网络或重试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
	saveItem.enabled = YES;
}
-(NSString*) loadingMessageForView:(KKNetworkLoadingView *) sender {
	return @"正在上传";
}
-(NSString*) failedMessageForView:(KKNetworkLoadingView *) sender {
	return @"上传失败";
}

@end
