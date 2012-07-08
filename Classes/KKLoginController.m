    //
//  KKLoginController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-27.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKLoginController.h"
#import "UserModel.h"
#import "RegisterController.h"

@implementation KKLoginController

@synthesize offsetHeight;

-(id) init {
	self = [super init];
	if (self != nil) {
		self.offsetHeight = 10;
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
	UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	bgImageView.image = [UIImage imageNamed:@"login_bg.jpg"];
	[self.view addSubview:bgImageView];
	[bgImageView release];
	// CGFloat offsetHeight = 55;
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, offsetHeight, 320, 120) style:UITableViewStyleGrouped];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.backgroundColor = [UIColor clearColor];
	tableView.scrollEnabled = NO;
	[self.view addSubview:tableView];
	
	accountField = [[UITextField alloc] initWithFrame:CGRectMake(68, 12, 232, 26)];
	//accountField.backgroundColor = [UIColor redColor];
	accountField.font = [UIFont systemFontOfSize:20];
	accountField.returnKeyType = UIReturnKeyNext;
	accountField.autocorrectionType = UITextAutocorrectionTypeNo;
	accountField.autocapitalizationType = UITextAutocapitalizationTypeNone; 
	accountField.clearButtonMode = UITextFieldViewModeWhileEditing;
	accountField.delegate = self;
	accountFieldTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, accountField.frame.size.width, accountField.frame.size.height - 8)];
	accountFieldTipLabel.backgroundColor = [UIColor clearColor];
	accountFieldTipLabel.text = @"输入帐号或邮箱";
	accountFieldTipLabel.textColor = [UIColor grayColor];
	accountFieldTipLabel.font = [UIFont systemFontOfSize:14];
	accountFieldTipLabel.tag = 100;
	[accountField addSubview:accountFieldTipLabel];
	
	
	passwordField = [[UITextField alloc] initWithFrame:accountField.frame];
	passwordField.font = accountField.font;
	passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
	passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone; 
	passwordField.secureTextEntry = YES;
	passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
	passwordField.delegate = self;
	[accountField becomeFirstResponder];
	
	passwordFieldTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, accountField.frame.size.width, accountField.frame.size.height - 8)];
	passwordFieldTipLabel.backgroundColor = [UIColor clearColor];
	passwordFieldTipLabel.text = @"输入登录密码";
	passwordFieldTipLabel.textColor = [UIColor grayColor];
	passwordFieldTipLabel.font = [UIFont systemFontOfSize:14];
	passwordFieldTipLabel.tag = 100;
	[passwordField addSubview:passwordFieldTipLabel];
	
	
	CGFloat buttonWidth = 136;
	CGFloat buttonHeight = 40;
	loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	loginButton.frame = CGRectMake((320 / 2 - buttonWidth) / 2  + (320 / 2), tableView.frame.origin.y + tableView.frame.size.height + 10, buttonWidth, buttonHeight);
	[self.view addSubview:loginButton];
	
	registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	registerButton.frame = CGRectMake((320 / 2 - buttonWidth) / 2, tableView.frame.origin.y + tableView.frame.size.height + 10, buttonWidth, buttonHeight);
	[self.view addSubview:registerButton];
	
	[loginButton setTitle:@"登   录" forState:UIControlStateNormal];
	[registerButton setTitle:@"注册新帐号" forState:UIControlStateNormal];
	[registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
	

	[loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	[registerButton addTarget:self action:@selector(showRegister) forControlEvents:UIControlEventTouchUpInside];
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == accountField) {
		[accountField resignFirstResponder];
		[passwordField becomeFirstResponder];
	}
	return YES;
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
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[accountField release];
	[passwordField release];
	[tableView release];
	[accountFieldTipLabel release];
	[passwordFieldTipLabel release];
    [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}


-(CGFloat) tableView:(UITableView *) _tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 50;
}

- (UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"logincell"];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 45, 30)];
	label.font = [UIFont boldSystemFontOfSize:18];
	[cell addSubview:label];
	if ([indexPath row] == 0) {
		label.text = @"帐号:";
		[cell addSubview:accountField];
	} else if ([indexPath row] == 1) {
		label.text = @"密码:";
		[cell addSubview:passwordField];
	}
	[label release];
	return [cell autorelease];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == accountField) {
		//[textField viewWithTag:100].hidden = YES;
		/*if ([textField.text length] == 0) {
			accountFieldTipLabel.hidden = NO;
		} else {
			accountFieldTipLabel.hidden = YES;
		}*/
		accountFieldTipLabel.hidden = YES;
	} else if (textField == passwordField) {
		/*if ([textField.text length] == 0) {
			passwordFieldTipLabel.hidden = NO;
		} else {
			passwordFieldTipLabel.hidden = YES;
		}*/
		passwordFieldTipLabel.hidden = YES;
	}
	return YES;
}

-(void) loginWithName:(NSString *) name andToken:(NSString*) token {
	[[UserModel getInstance] loginWithUserName:name token:token];
}

-(void) login {
	NSString* account = accountField.text;
	NSString* password = passwordField.text;
	if ([account length] == 0 || [password length] == 0) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"帐号或密码不能为空" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	[[UserModel getInstance] loginWithAccount:account password:password];
	//[[UserModel getInstance] loginWithUserName:account token:password];
}

-(void) showRegister {
	RegisterController* registerController = [[RegisterController alloc] init];
	registerController.delegate = self;
	[self presentModalViewController:registerController animated:YES];
	[registerController release];
}

-(void) afterRegister:(NSString*) name token:(NSString*) token {
	[self.modalViewController dismissModalViewControllerAnimated:NO];
	[[UserModel getInstance] loginWithUserName:name token:token];
}
@end
