    //
//  KKUserSwitchController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-25.
//  Copyright 2011 tencent. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "KKUserSwitchController.h"
#import "UserModel.h"
#import "UIImageView+ASYNC.h"
#import "KKLoginController.h"


@interface SizableImageCell : UITableViewCell {}
@end
@implementation SizableImageCell
- (void)layoutSubviews {
    [super layoutSubviews];
	
    float desiredWidth = 50;
    float w=self.imageView.frame.size.width;
    if (w>desiredWidth) {
        float widthSub = w - desiredWidth;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,desiredWidth,self.imageView.frame.size.height);
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x-widthSub,self.textLabel.frame.origin.y,self.textLabel.frame.size.width+widthSub,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x-widthSub,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width+widthSub,self.detailTextLabel.frame.size.height);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
		
		self.imageView.layer.masksToBounds = YES;
		self.imageView.layer.cornerRadius = 8.0;
		self.imageView.layer.borderWidth = 0.0;
		self.imageView.layer.borderColor = [[UIColor clearColor] CGColor];
    }
}
@end


@implementation KKUserSwitchController

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
	self.title = @"帐号切换";
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) 
													  style:UITableViewStyleGrouped];
	tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	
	editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
	self.navigationItem.rightBarButtonItem = editItem;
	
	finishedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditTable)];
	
	userStore = [[KKUserStore alloc] init];
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
	[userStore release];
	[tableView release];
	[finishedItem release];
	[editItem release];
    [super dealloc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [userStore getUserNum];
	}
	return 1;
}


-(CGFloat) tableView:(UITableView *) _tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	if ([indexPath section] == 0) {
		return 70;
	}
	return 50;
}

- (UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell* cell = nil;
	
	if ([indexPath section] == 0) {
		cell = [[SizableImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"usertestcell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary* info = [userStore getUser:[indexPath row]];
		/*
		UILabel* nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
		NSString* nick = [info objectForKey:@"user_nick"];
		nickLabel.text = nick;
		[cell addSubview:nickLabel];
		[nickLabel release];
		CGFloat width = [nick sizeWithFont:nickLabel.font].width;
		
		UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 + width + 2, 10, 100, 30)];
		NSString* name = [NSString stringWithFormat:@"(@%@)", [info objectForKey:@"user_name"]];
		nameLabel.text = name;
		nameLabel.textColor = [UIColor grayColor];
		[cell addSubview:nameLabel];
		[nameLabel release];
		 */
		cell.textLabel.text = [info objectForKey:@"user_nick"];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"(@%@)", [info objectForKey:@"user_name"]];
		NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										  [info objectForKey:@"user_name"], @"id", indexPath, @"indexPath", nil];
		
		cell.imageView.layer.masksToBounds = YES;
		cell.imageView.layer.cornerRadius = 8.0;
		cell.imageView.layer.borderWidth = 0.0;
		cell.imageView.layer.borderColor = [[UIColor clearColor] CGColor];
		
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [info objectForKey:@"head_image_id"]];
		//cell.imageView.frame.size.width = 10;
		[cell.imageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:imageInfo];
		
		//NSLog(@"name:%@, user:%@", [info objectForKey:@"user_name"], [[UserModel getInstance] getUserName]);
		if ([[info objectForKey:@"user_name"] isEqualToString:[[UserModel getInstance] getUserName]]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
	} else {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"usertestcell"];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.text = @"添加新帐号";
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return [cell autorelease];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == 1) {
		return NO;
	}
    return YES;
} 

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
} 

-(void) editTable {
	[tableView setEditing:YES animated:YES];
	self.navigationItem.rightBarButtonItem = finishedItem;
}

-(void) finishEditTable {
	[tableView setEditing:NO animated:YES];
	self.navigationItem.rightBarButtonItem = editItem;
}

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSDictionary* info = [[userStore getUser:[indexPath row]] retain];
		NSString* userName = [info objectForKey:@"user_name"];
		//NSLog(@"the delete userName:%@", userName);
		[userStore deleteUser:userName];
		//NSLog(@"the cell count:%d", [userStore getUserNum]);
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		if ([userName isEqualToString:[[UserModel getInstance] getUserName]]) {
			self.navigationItem.hidesBackButton = YES;
			[[UserModel getInstance] clearCurrentUser];
		}
		
		[info release];

	} 
}

-(void) showsLoginControl {
	KKLoginController* controller = [[KKLoginController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] == 1) {
		[self showsLoginControl];
	} else {
		NSDictionary* info = [[userStore getUser:[indexPath row]] retain];
		[[UserModel getInstance] loginWithUserName:[info objectForKey:@"user_name"] token:[info objectForKey:@"token"]];
		[info release];
	}
}



@end
