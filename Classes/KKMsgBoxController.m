    //
//  KKMsgBoxController.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgBoxController.h"
#import "UIImage+Resize.h"
#import "ComposeMsgController.h"


@implementation KKMsgBoxController

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
	self.title = @"草稿箱";
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) 
											 style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self.view addSubview:tableView];
	
	editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTable)];
	self.navigationItem.rightBarButtonItem = editItem;
	
	finishedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEditTable)];
	
	msgStore = [[KKMsgBoxStore alloc] init];
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
	[msgStore release];
	[tableView release];
	[finishedItem release];
	[editItem release];
    [super dealloc];
}

-(void) editTable {
	[tableView setEditing:YES animated:YES];
	self.navigationItem.rightBarButtonItem = finishedItem;
}

-(void) finishEditTable {
	[tableView setEditing:NO animated:YES];
	self.navigationItem.rightBarButtonItem = editItem;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog(@"the msg num:%d", [msgStore getMsgNum]);
	return [msgStore getMsgNum];
}


-(CGFloat) tableView:(UITableView *) _tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 70;
}

- (UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		UITableViewCell* cell = nil;
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"msgboxcell"];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		NSDictionary* info = [msgStore getMsg:[indexPath row]];
		cell.textLabel.text = [info objectForKey:@"msg"];
		NSData* imageData = [info objectForKey:@"image"];
		if (imageData != nil) {
			UIImage* image = [UIImage imageWithData:imageData];
			cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
			cell.imageView.image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationHigh];;
		}
	/*
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
	 */
		
	return [cell autorelease];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
} 

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
} 

- (void)tableView:(UITableView *)_tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSDictionary* info = [[msgStore getMsg:[indexPath row]] retain];
		NSString* msgboxId = [info objectForKey:@"msgboxId"];
		[msgStore deleteMsg:msgboxId];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[info release];
		
	} 
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary* info = [[msgStore getMsg:[indexPath row]] retain];
	ComposeMsgController* controller = [[ComposeMsgController alloc] initWithMsgBox:info];
	//[self.navigationController pushViewController:controller animated:YES];
	[self presentModalViewController:controller animated:YES];
	[controller release];
	// [[UserModel getInstance] loginWithUserName:[info objectForKey:@"user_name"] token:[info objectForKey:@"token"]];
	[info release];
}

@end
