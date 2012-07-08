    //
//  MoreNavController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "MoreNavController.h"
#import "KKIconView.h"
#import "KKIconPageView.h"
#import "KKIconItem.h"
#import "KKUserSwitchController.h"
#import "KKModifyProfileController.h"
#import "UserModel.h"
#import "KKUserInfoController.h"
#import <QuartzCore/QuartzCore.h>
#import "KKMsgBoxController.h"
#import	"KKAboutController.h"
#import "ComposeMsgController.h"
#import "KKDefaultUserController.h"

@implementation MoreNavController

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"更多";
	self.view.backgroundColor = [UIColor whiteColor];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 342)];
	//scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
	//scrollView.backgroundColor = [UIColor redColor];
	[self.view addSubview:scrollView];
	
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.scrollsToTop = NO;
	scrollView.delegate = self;
	scrollView.pagingEnabled = YES;
	
	
	pageControl = [[KKPageControl alloc] initWithFrame:CGRectMake(30, 342, self.view.frame.size.width - 60, 20)];
	
	//[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:pageControl];
	
	pageControl.backgroundColor = [UIColor clearColor];
	//pageControl.hidesForSinglePage = NO;
	//pageControl.numberOfPages = 5;
	pageControl.currentPage = 0;
	
	pageControl.layer.masksToBounds = YES;
	pageControl.layer.cornerRadius = 8.0;
	pageControl.layer.borderWidth = 0.0;
	pageControl.layer.borderColor = [[UIColor clearColor] CGColor];
	
	pageControlUsed = NO;
	
	NSMutableArray* list = [[NSMutableArray alloc] init];
	
	KKIconItem* item1 = [[KKIconItem alloc] initWithText:@"我的资料" image:[UIImage imageNamed:@"profile.png"] target:self action:@selector(showProfile:)];
	[list addObject:item1];
	[item1 release];
	
    KKIconItem* item0 = [[KKIconItem alloc] initWithText:@"积分榜" image:[UIImage imageNamed:@"scoreboard.png"] target:self action:@selector(showUserRanking:)];
	[list addObject:item0];
	[item0 release];
    
	KKIconItem* item2 = [[KKIconItem alloc] initWithText:@"帐号切换" image:[UIImage imageNamed:@"users.png"] target:self action:@selector(changeUser:)];
	[list addObject:item2];
	[item2 release];
	
	KKIconItem* item3 = [[KKIconItem alloc] initWithText:@"草稿箱" image:[UIImage imageNamed:@"msgbox.png"] target:self action:@selector(showMsgBox:)];
	[list addObject:item3];
	[item3 release];

	KKIconItem* item4 = [[KKIconItem alloc] initWithText:@"退出登录" image:[UIImage imageNamed:@"logout_icon.png"] target:self action:@selector(logoutAccount:)];
	[list addObject:item4];
	[item4 release];
	
	KKIconItem* item5 = [[KKIconItem alloc] initWithText:@"意见反馈" image:[UIImage imageNamed:@"idea_icon.jpg"] target:self action:@selector(showIdea:)];
	[list addObject:item5];
	[item5 release];
	
	KKIconItem* item6 = [[KKIconItem alloc] initWithText:@"关于" image:[UIImage imageNamed:@"about_icon.png"] target:self action:@selector(showAbout:)];
	[list addObject:item6];
	[item6 release];
	
	/*
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
		[list addObject:item1];
	 */
		
	
	
	CGFloat iconWidth = 319 / 3.0;
	CGFloat iconHeight = 341 / 3.0;
	
	NSInteger columnNum = (NSInteger) (scrollView.frame.size.width / iconWidth);
	if (columnNum <= 0) {
		columnNum = 1;
	}
	NSInteger rowNum = (NSInteger) ((scrollView.frame.size.height) / iconHeight);
	if (rowNum <= 0) {
		rowNum = 1;
	}
	
	NSInteger pageNum = ([list count] + rowNum * columnNum - 1) / (rowNum * columnNum);
	if (pageNum <= 0) {
		pageNum = 1;
	}
	
	scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageNum, scrollView.frame.size.height);
	pageControl.numberOfPages = pageNum;
	for (int i = 0; i < [list count]; i++) {
		id obj = [list objectAtIndex:i];
		if (![obj isKindOfClass:[KKIconItem class]]) {
			continue;
		}
		KKIconItem* item = (KKIconItem *) obj;
		NSInteger pageNo = i / (rowNum * columnNum);
		NSInteger rowNo = (i % (rowNum * columnNum)) / columnNum;
		NSInteger columnNo = (i % (rowNum * columnNum)) % columnNum;
		//NSLog(@"pageNo:%d, [%d,%d]", pageNo, rowNo, columnNo);
		KKIconView* tmpView = [[KKIconView alloc] initWithFrame:CGRectMake(
			pageNo * scrollView.frame.size.width + columnNo * iconWidth, rowNo * iconHeight, iconWidth, iconHeight)];
		[tmpView setText:item.text];
		[tmpView setImage:item.image];
		
		UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:item.target action:item.action];
		[tmpView addGestureRecognizer:recognizer];
		[recognizer release];
		[scrollView addSubview:tmpView];
		[tmpView release];
	}
	[list release];
}


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
	[pageControl release];
	[scrollView release];
    [super dealloc];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

-(void)changePage:(id)sender
{
	int page = pageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

-(void) changeUser:(id) sender {
	//NSLog(@"trigger");
	KKUserSwitchController* controller = [[KKUserSwitchController alloc] init];
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) showUserRanking:(id) sender {
	//NSLog(@"trigger");
    NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/user/ranking/"];
	KKDefaultUserController* controller = [[KKDefaultUserController alloc] initWithUserURL:url];
    controller.title = @"用户积分榜";
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

/*
-(void) modifyProfile:(id) sender {
	//NSLog(@"trigger");
	KKModifyProfileController* controller = [[KKModifyProfileController alloc] init];
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}
 */

-(void) showMsgBox:(id) sender {
	//NSLog(@"trigger");
	KKMsgBoxController* controller = [[KKMsgBoxController alloc] init];
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) showProfile:(id) sender {
	//NSLog(@"trigger");
	NSDictionary* userInfo = [[[UserModel getInstance] getUserInfo] retain];
	KKUserInfoController* controller = [[KKUserInfoController alloc] initWithUserInfo:userInfo];
	[userInfo release];
	//controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) showLogoutAlert:(id) sender {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"真的要退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil]; 
	[alert show];
	[alert release];
}

-(void) showAbout:(id) sender {
	KKAboutController* controller = [[KKAboutController alloc] init];
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

-(void) logoutAccount:(id) sender {
	//NSLog(@"trigger logout ...");
	[self performSelector:@selector(showLogoutAlert:) withObject:nil afterDelay:0.10];

	
	 
}

-(void) showIdea:(id) sender {
	NSString* msg = [NSString stringWithFormat:@"@140m #iPhone意见反馈#，版本:%@ ", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
	ComposeMsgController* controller = [[ComposeMsgController alloc] initWithInitMsg:msg];
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[[UserModel getInstance] logout];
	}
}


@end
