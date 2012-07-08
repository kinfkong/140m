    //
//  KKLocationUserController.m
//  obanana
//
//  Created by Wang Jinggang on 11-8-10.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKLocationUserController.h"
#import "UtilModel.h"
#import "KKBoundCalculator.h"
#import "KKUserInfoController.h"

@implementation KKLocationUserController

@synthesize userListView;

-(id) initWithLocation:(CLLocationCoordinate2D) location {
	self = [super init];
	if (self != nil) {
		theLocation = location;
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
	self.title = @"到过当地的用户";
	userListView = [[KKUserListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	userListView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	KKBound bound = [KKBoundCalculator calcBound:theLocation radius:140];
	[userListView setURL:[NSString stringWithFormat:@"http://m.obanana.com/index.php/nearby/user/%.5lf,%.5lf,%.5lf,%.5lf/", 
						  bound.minLng, bound.minLat, bound.maxLng, bound.maxLat]];
	userListView.userListdelegate = self;
	[self.view addSubview:userListView];
	[userListView refresh];
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
	[userListView release];
    [super dealloc];
}

-(NSString *) userList:(KKUserListView*) userList modifyDescriptionLabelText:(NSString *) description {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* date2 =  [formatter stringFromDate:[NSDate date]];
	NSString* result = [[UtilModel getInstance] getReadableDateDiffBetweenDate1:description andDate2:date2];
	[formatter release];
	if ([result isEqualToString:@"刚刚"]) {
		return [NSString stringWithFormat:@"刚刚在这里"];
	} else {
		return [NSString stringWithFormat:@"%@前在这里", result];
	}
}

-(void) userList:(KKUserListView*) userList didTouchAt:(NSIndexPath *) indexPath {
	//KKUserListView* userListView = (KKUserListView*) [self.view viewWithTag:100];
	NSDictionary* data = [userListView getMsgDataAt:(NSIndexPath *) indexPath];
	//NSLog(@"The data:%@", data);
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:data];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end
