    //
//  KKUserInfoController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-4.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKUserInfoController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+ASYNC.h"
#import "KKNetworkLoadingView.h"
#import "UserModel.h"
#import "KKFootprintController.h"
#import "ComposeMsgController.h"
#import "KKModifyProfileController.h"
#import "KKDataVersionManager.h"
#import "UtilModel.h"
#import "KKDefaultMsgController.h"
#import "KKDefaultUserController.h"
#import "KKDefaultLocationController.h"


enum KKUserInfoButtonTag {
	KKUserInfoButtonUserFollow = 777,
	KKUserInfoButtonCancelUserFollow,
};

@interface KKUserInfoController (private)
-(void) drawTableWithData:(NSDictionary *) data;
@end

@implementation KKUserInfoController

@synthesize userInfo;
@synthesize fullUserInfo;

-(id) initWithUserName:(NSString *) _userName {
	NSDictionary* tmp = [NSDictionary dictionaryWithObjectsAndKeys:_userName, @"user_name", @"", @"user_nick", @"1", @"head_image_id", nil];
	return [self initWithUserInfo:tmp];
}

-(id) initWithUserInfo:(NSDictionary *) _userInfo {
	self = [super init];
	if (self != nil) {
		self.userInfo = _userInfo;
	}
	return self;
}

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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	self.title = @"个人资料";
	/*
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 250, 30)];
	label.text = @"coming soon...";
	[self.view addSubview:label];
	[label release];
	 */
	if ([[[UserModel getInstance] getUserName] isEqualToString:[self.userInfo objectForKey:@"user_name"]]) {
		editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(modifyProfile)];
		self.navigationItem.rightBarButtonItem = editItem;
		editItem.enabled = NO;
		
		//self.userInfo = [[UserModel getInstance] getUserInfo];
		[[KKDataVersionManager getInstance] updated:@"userInfo"];
	}
	
	self.view.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
	UIImageView* authorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
	authorImageView.tag = 321;
	[self.view addSubview:authorImageView];
	[authorImageView release];
	
	authorImageView.layer.masksToBounds = YES;
	authorImageView.layer.cornerRadius = 4.0;
	authorImageView.layer.borderWidth = 0.0;
	authorImageView.layer.borderColor = [[UIColor clearColor] CGColor];
	authorImageView.userInteractionEnabled = YES;
	

	
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [self.userInfo objectForKey:@"head_image_id"]];
	[authorImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:nil];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 320 - 65, 25)];
	label.font = [UIFont boldSystemFontOfSize:18.0f];
	label.tag = 100;
	label.backgroundColor = [UIColor clearColor];
	label.text = [self.userInfo objectForKey:@"user_nick"];
	label.textColor = [UIColor whiteColor];
	[self.view addSubview:label];
	[label release];
	
	UILabel* namelabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 35, 320 - 65, 20)];
	namelabel.font = [UIFont systemFontOfSize:16.0f];
	namelabel.backgroundColor = [UIColor clearColor];
	namelabel.tag = 101;
	namelabel.text = [NSString stringWithFormat:@"@%@",[self.userInfo objectForKey:@"user_name"]];
	namelabel.textColor = [UIColor whiteColor];
	[self.view addSubview:namelabel];
	[namelabel release];
	
	UILabel* relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 15, 320 - 180, 20)];
	relationLabel.font = [UIFont systemFontOfSize:16.0f];
	relationLabel.backgroundColor = [UIColor clearColor];
	relationLabel.tag = 102;
	relationLabel.text = @"";
	relationLabel.textAlignment = UITextAlignmentCenter;
	relationLabel.textColor = [UIColor grayColor];
	[self.view addSubview:relationLabel];
	[relationLabel release];
    
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 35, 320 - 180, 20)];
    scoreLabel.tag = 7689;
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:237.0/255.0 alpha:1.0];
    scoreLabel.textAlignment = UITextAlignmentCenter;
    //scoreLabel.text = [NSString stringWithFormat:@"积分: %@", ];
    [self.view addSubview:scoreLabel];
	
	UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, 320, self.view.frame.size.height - 65) style:UITableViewStyleGrouped] ;
	tableView.tag = 301;
	tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.view addSubview:tableView];
	[tableView release];
	
	NSString* urlstr = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/showUserProfile/%@/%@", 
						[[UserModel getInstance] getUserName], [self.userInfo objectForKey:@"user_name"]];
	NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
	
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:urlrequest delegate:self];
	[self.view addSubview:loadingView];
	[loadingView release];
	

}


-(void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (![[self.userInfo objectForKey:@"user_name"] isEqualToString:[[UserModel getInstance] getUserName]]) {
		return;
	}
	
	if (![[KKDataVersionManager getInstance] shouldUpdate:@"userInfo"]) {
		return;
	}
	
	NSString* urlstr = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/showUserProfile/%@/%@", 
						[[UserModel getInstance] getUserName], [self.userInfo objectForKey:@"user_name"]];
	NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];
	
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:urlrequest delegate:self];
	[self.view addSubview:loadingView];
	[loadingView release];
	editItem.enabled = NO;
	[[KKDataVersionManager getInstance] updated:@"userInfo"];
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


- (void)dealloc {
	[userInfo release];
	[fullUserInfo release];
	[editItem release];
    [super dealloc];
}

-(void) drawTableWithData:(NSDictionary *) data {
	NSString* relation = [data objectForKey:@"relation"];
	UILabel* relationLabel = (UILabel *) [self.view viewWithTag:102];
	if ([relation isEqualToString:@"ifollowhim"]) {
		relationLabel.text = @"(你收听了对方)";
	} else if ([relation isEqualToString:@"hefollowme"]) {
		relationLabel.text = @"(对方收听了你)";
	} else if ([relation isEqualToString:@"both"]) {
		relationLabel.text = @"(你们已互相收听)";
	} else if ([relation isEqualToString:@"nofollow"]) {
		relationLabel.text = @"(你们还没互相收听)";
	} else if ([relation isEqualToString:@"self"]) {
		relationLabel.text = @"";
	}
	self.fullUserInfo = data;
    
    UILabel* scoreLabel = (UILabel *) [self.view viewWithTag:7689];
    scoreLabel.text = [NSString stringWithFormat:@"积分: %@", [self.fullUserInfo objectForKey:@"score"]];
	
	UITableView* tableView = (UITableView *) [self.view viewWithTag:301];
	tableView.delegate = self;
	tableView.dataSource = self;
	[tableView reloadData];
	
	editItem.enabled = YES;
	//NSLog(@"full user info:%@", self.fullUserInfo);
	NSDictionary* newUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:[fullUserInfo objectForKey:@"name"], @"user_name",
								 [fullUserInfo objectForKey:@"nick"], @"user_nick", [fullUserInfo objectForKey:@"head_image_id"], @"head_image_id", nil];
	self.userInfo = newUserInfo;
	//NSLog(@"the userInfo:%@", self.userInfo);
	UIImageView* authorImageView = (UIImageView *) [self.view viewWithTag:321];
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [self.userInfo objectForKey:@"head_image_id"]];
	[authorImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:nil];
	//[[KKDataVersionManager getInstance] updated:@"userInfo"];
	
	UILabel* label = (UILabel *) [self.view viewWithTag:100];
	label.text = [self.userInfo objectForKey:@"user_nick"];
}

-(void) view:(KKNetworkLoadingView *) sender onFinishedLoading:(NSDictionary *)data {
	if (sender.tag == KKUserInfoButtonUserFollow || sender.tag == KKUserInfoButtonCancelUserFollow) {
		NSString* urlstr = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/showUserProfile/%@/%@", 
							[[UserModel getInstance] getUserName], [self.userInfo objectForKey:@"user_name"]];
		NSURLRequest* urlrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]];		
		KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:urlrequest delegate:self];
		[self.view addSubview:loadingView];
		[loadingView release];
		return;
	}
	[self drawTableWithData:[data objectForKey:@"detail"]];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
		return 1;
	} else if (section == 1) {
		return 2;
	} else if (section == 2) {
		return 1;
	}
	return 0;
}


-(CGFloat) tableView:(UITableView *) _tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		NSString* info = [self.fullUserInfo objectForKey:@"description"];
		if (info == nil || [info isEqualToString:@""]) {
			return 50;
		}
		CGFloat height = [info sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(235, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height;
		height += 10;
		if (height < 50) {
			return 50;
		}
		return height;
	} else if ([indexPath section ] == 2) {
		return 40;
	}
	return 50;
}

- (UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"testcell"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	if ([indexPath section] == 0 && [indexPath row] == 0) {
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 40, 20)];
		label.text = @"简介:";
		label.textColor = [UIColor grayColor];
		//label.backgroundColor = [UIColor redColor];
		[cell addSubview:label];
		[label release];
		
		NSString* info = [self.fullUserInfo objectForKey:@"description"];
		if (info == nil || [info isEqualToString:@""]) {
			info = @"还没写简介...";
		} 
		CGFloat height = [info sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(235, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height;
	
		UILabel* description = [[UILabel alloc] initWithFrame:CGRectMake(65, 5, 235, height)];

		description.numberOfLines = 0;
		description.lineBreakMode = UILineBreakModeWordWrap;
		
		description.font = [UIFont systemFontOfSize:18];
		description.text = info;
		// description.backgroundColor = [UIColor redColor];
		[cell addSubview:description];
		[description release];
	} else if ([indexPath section] == 1) {
		
		// UIView* subcell1 = [[UIView alloc] initWithFrame:CGRectMake(20, 5, 130, 60)];
		UIButton* subcell1 = [UIButton buttonWithType:UIButtonTypeCustom];
		subcell1.frame = CGRectMake(20, 5, 130, 40);
		UILabel* number1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
		UILabel* tag1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 130, 20)];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(320 / 2, 0, 1, 44)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.autoresizingMask = 0x3f;
        [cell addSubview:lineView];
        [lineView release];
		
		
		//UIView* subcell2 = [[UIView alloc] initWithFrame:CGRectMake(170, 5, 130, 60)];
		UIButton* subcell2 = [UIButton buttonWithType:UIButtonTypeCustom];
		subcell2.frame = CGRectMake(170, 5, 130, 40);
		UILabel* number2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 20)];
		UILabel* tag2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 130, 20)];
		
		
		number1.textAlignment  = UITextAlignmentCenter;
		tag1.textAlignment = UITextAlignmentCenter;
		number2.textAlignment  = UITextAlignmentCenter;
		tag2.textAlignment = UITextAlignmentCenter;
		
		number1.textColor = [UIColor blueColor];
		number2.textColor = [UIColor blueColor];
		
		if ([indexPath row] == 0) {
			tag1.text = @"消息";
			number1.text = [self.fullUserInfo objectForKey:@"outbox_count"];
			tag2.text = @"收听地点";
			number2.text = [self.fullUserInfo objectForKey:@"lfollow_count"];
			
			[subcell1 addTarget:self action:@selector(showUserMessages) forControlEvents:UIControlEventTouchUpInside];
			[subcell2 addTarget:self action:@selector(showFollowLocations) forControlEvents:UIControlEventTouchUpInside];
			
		} else {
			tag1.text = @"粉丝";
			number1.text = [self.fullUserInfo objectForKey:@"fans_count"];
			tag2.text = @"收听用户";
			number2.text = [self.fullUserInfo objectForKey:@"ufollow_count"];
			[subcell1 addTarget:self action:@selector(showFans) forControlEvents:UIControlEventTouchUpInside];
			[subcell2 addTarget:self action:@selector(showFollowUsers) forControlEvents:UIControlEventTouchUpInside];
		}
		[subcell1 addSubview:number1];
		[subcell1 addSubview:tag1];
		[number1 release];
		[tag1 release];
		
		[subcell2 addSubview:number2];
		[subcell2 addSubview:tag2];
		[number2 release];
		[tag2 release];
		
		[cell addSubview:subcell1];
		[cell addSubview:subcell2];
		
		//[subcell1 release];
		// [subcell2 release];
	} else if ([indexPath section] == 2) {
		UILabel* tag = [[UILabel alloc] initWithFrame:CGRectMake((320 - 260) / 2, 5, 260, 30)];
        tag.backgroundColor = [UIColor clearColor];
		tag.textAlignment = UITextAlignmentCenter;
		tag.text = @"查看足迹";
        tag.textColor = [UIColor whiteColor];
		UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.backgroundColor = [UIColor clearColor];
		button.frame = tag.frame;
		[button addTarget:self action:@selector(lookatFootprint:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:tag];
		[cell addSubview:button];
        cell.backgroundColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:237.0/255.0 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[tag release];
	}
	return [cell autorelease];
}

-(void) showUserMessages {
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/post/user/%@/", [userInfo objectForKey:@"user_name"]];
	KKDefaultMsgController* controller = [[KKDefaultMsgController alloc] initWithMsgURL:url];
	controller.title = [NSString stringWithFormat:@"%@发出的消息", [userInfo objectForKey:@"user_nick"]];;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) showFollowLocations {
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/location/%@/",
					 [userInfo objectForKey:@"user_name"]];
	//NSLog(@"the url:");
	KKDefaultLocationController* controller = [[KKDefaultLocationController alloc] initWithLocationURL:url];
	controller.title = [NSString stringWithFormat:@"%@收听的地点", [userInfo objectForKey:@"user_nick"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
-(void) showFans {
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/fans/%@/", 
					 [userInfo objectForKey:@"user_name"]];
	//NSLog(@"the url:");
	KKDefaultUserController* controller = [[KKDefaultUserController alloc] initWithUserURL:url];
	controller.title = [NSString stringWithFormat:@"%@的粉丝", [userInfo objectForKey:@"user_nick"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) showFollowUsers {
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/user/%@/", 
					 [userInfo objectForKey:@"user_name"]];
	//NSLog(@"the url:");
	KKDefaultUserController* controller = [[KKDefaultUserController alloc] initWithUserURL:url];
	controller.title = [NSString stringWithFormat:@"%@收听的人", [userInfo objectForKey:@"user_nick"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	
}
-(void) lookatFootprint:(id) sender {
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/footprint/%@/", [userInfo objectForKey:@"user_name"]];
	/*
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/location/%@/",
					 [userInfo objectForKey:@"user_name"]];
	 */
	//NSLog(@"the url:");
	KKDefaultLocationController* controller = [[KKDefaultLocationController alloc] initWithLocationURL:url];
	//controller.delegate = self;
	controller.title = [NSString stringWithFormat:@"%@的足迹", [userInfo objectForKey:@"user_nick"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	/*
	KKFootprintController* controller = [[KKFootprintController alloc] initWithUserName:[userInfo objectForKey:@"user_name"]];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
	 */
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	NSString* relation = [self.fullUserInfo objectForKey:@"relation"];
	if ([relation isEqualToString:@"self"]) {
		return 0.0;
	}
	if (section == 0) {
		return 60;
	} else {
		return 0.0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString* relation = [self.fullUserInfo objectForKey:@"relation"];
	if ([relation isEqualToString:@"self"]) {
		return nil;
	}
	if (section == 0) {
		
		UIView* headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
		//view.backgroundColor = [UIColor clearColor];
		
		UIButton* follow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		follow.frame = CGRectMake(10, 10, 90, 35);
		NSString* buttonTitle = @"";
		if ([relation isEqualToString:@"both"] || [relation isEqualToString:@"ifollowhim"]) {
			buttonTitle = @"取消收听";
			[follow addTarget:self action:@selector(cancelUFollow) forControlEvents:UIControlEventTouchUpInside];
		} else {
			buttonTitle = @"加收听";
			[follow addTarget:self action:@selector(addUFollow) forControlEvents:UIControlEventTouchUpInside];
		}
		[follow setTitle:buttonTitle forState:UIControlStateNormal];
		[headview addSubview:follow];
		
		
		UIButton* at = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		at.frame = CGRectMake(110, 10, 90, 35);
		[at setTitle:@"@他/她" forState:UIControlStateNormal];
		[at addTarget:self action:@selector(showAtHimCompose:) forControlEvents:UIControlEventTouchUpInside];
		[headview addSubview:at];
		
		UIButton* more = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		more.frame = CGRectMake(210, 10, 90, 35);
		[more setTitle:@"私信" forState:UIControlStateNormal];
		[headview addSubview:more];
		[more addTarget:self action:@selector(showPrivateMailComposor:) forControlEvents:UIControlEventTouchUpInside];
		

		
		return [headview autorelease];
	}
	return nil;
}

-(void) addUFollow {
	// upload the follow location
	NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
	UtilModel* utilModel = [UtilModel getInstance];
	[data setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
	[data setObject:[[UserModel getInstance] getToken] forKey:@"token"];
	[data setObject:[self.userInfo objectForKey:@"user_name"] forKey:@"follow"];
	//NSLog(@"the data:%@", modificationData);
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/follow/upu/" 
											  PostDictionary:data];
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self tag:KKUserInfoButtonUserFollow];
	[self.view addSubview:loadingView];
	[loadingView release];
	[data release];	
}

-(void) cancelUFollow {
	// upload the follow location
	NSMutableDictionary* data = [[NSMutableDictionary alloc] init];
	UtilModel* utilModel = [UtilModel getInstance];
	[data setObject:[[UserModel getInstance] getUserName] forKey:@"user_name"];
	[data setObject:[[UserModel getInstance] getToken] forKey:@"token"];
	[data setObject:[self.userInfo objectForKey:@"user_name"] forKey:@"follow"];
	//NSLog(@"the data:%@", modificationData);
	NSURLRequest* request = [utilModel generateRequesWithURL:@"http://m.obanana.com/index.php/follow/deluserfollow/" 
											  PostDictionary:data];
	KKNetworkLoadingView* loadingView = [[KKNetworkLoadingView alloc] initWithRequest:request delegate:self tag:KKUserInfoButtonCancelUserFollow];
	[self.view addSubview:loadingView];
	[loadingView release];
	[data release];	
}

-(void) showPrivateMailComposor:(id) sender {
	ComposeMsgController* controller = [[ComposeMsgController alloc] initWithPrivateMail:self.userInfo];
	[self presentModalViewController:controller animated:YES];
	[controller release];
	
}

-(void) showAtHimCompose:(id) sender {
	ComposeMsgController* controller = [[ComposeMsgController alloc] initWithInitMsg:[NSString stringWithFormat:@"@%@ ", [self.userInfo objectForKey:@"user_name"]]];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

-(void) modifyProfile {
	//NSLog(@"trigger");
	KKModifyProfileController* controller = [[KKModifyProfileController alloc] initWithUserInfo:self.fullUserInfo];
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}




@end
