//
//  KKMsgListView.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-23.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgListView.h"
#import "KKMoreTableFooterView.h"
#import "KKMsgListCellView.h"
#import <CoreLocation/CoreLocation.h>


@implementation KKMsgListView

@synthesize delegate;
@synthesize replyHidden;

- (id)initWithFrame:(CGRect)frame initWithUpdateURL:(NSString *)url andIdentifier:(NSString *) identifier {
	return [self initWithFrame:frame initWithUpdateURL:url andIdentifier:identifier controller:nil];
}
- (id)initWithFrame:(CGRect)frame initWithUpdateURL:(NSString *)url andIdentifier:(NSString *) identifier controller:(UIViewController *) controller {
    
    self = [super initWithFrame:frame];
    if (self) {
		showBanner = NO;
		if (controller != nil) {
			adBanner = [[GADBannerView alloc]
						initWithFrame:CGRectMake(0.0,
												 0.0,
												 GAD_SIZE_320x50.width,
												 GAD_SIZE_320x50.height)];
			adBanner.adUnitID = @"a14e4519fbf0380";
			adBanner.rootViewController = controller;
            
			[adBanner loadRequest:[GADRequest request]];
			adBanner.delegate = self;
			
		}
		
		self.replyHidden = NO;
		self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		tableView = [[UITableView alloc] initWithFrame:frame];
		tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		tableView.delegate = self;
		tableView.dataSource = self;
		[self addSubview:tableView];
		
		_refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 
		-tableView.bounds.size.height, 
		tableView.frame.size.width, 
		self.bounds.size.height)]; 
		
		_refreshHeaderView.delegate = self; 
		[tableView addSubview:_refreshHeaderView];
		[_refreshHeaderView refreshLastUpdatedDate];
		
		footerView = nil;
		
		updateLock = [[NSCondition alloc] init];
		
		msgStore = [[KKMsgStore alloc] initWithUpdateURL:url andIdentifier:identifier];
		[msgStore load];
		[tableView reloadData];
		
    }
    return self;
}

-(void) setBannerWithController:(UIViewController *) controller {
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[footerView release];
	[tableView release];
	[_refreshHeaderView release];
	[msgStore release];
	[updateLock release];
    adBanner.delegate = nil;
	[adBanner release];
    [super dealloc];
}

-(void) reloadTableViewDataSource {
	_reloading = YES;
}

-(void) doneLoadingTableViewData:(id) obj {
	_reloading = NO;

	[tableView reloadData];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
	
}

-(void) doneLoadingMoreTableViewData:(NSNumber *) number {
	[footerView kkMoreScrollViewDataSourceDidFinishedLoading:tableView];
	
	if ([number intValue] > 0) {
		[tableView reloadData];
	
		[footerView removeFromSuperview];
		footerView = nil;
	}
	
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
	if (footerView == nil && [msgStore getMsgNum] >= 40 && scrollView.contentSize.height >= scrollView.frame.size.height) {
		footerView = [[KKMoreTableFooterView alloc] initWithFrame:CGRectMake(0, scrollView.contentSize.height, scrollView.frame.size.width, scrollView.frame.size.height)];
		footerView.delegate = self;
		[tableView addSubview:footerView];	
	}
	[footerView kkMoreScrollViewDidScroll:scrollView];
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}


-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{ 
    [self reloadTableViewDataSource];
	[NSThread detachNewThreadSelector:@selector(refreshMsgList:) toTarget:self withObject:nil];
}

- (void)kkMoreTableFooterDidTriggerMore:(KKMoreTableFooterView*)view {
	[NSThread detachNewThreadSelector:@selector(moreMsgList:) toTarget:self withObject:nil];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{ 
    return _reloading; 
} 

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{ 
    return [NSDate date];
}

-(void) refresh {
	[tableView setContentOffset:CGPointMake(0, -100)];
	[self scrollViewDidEndDragging:tableView willDecelerate:NO];
}

-(void) cleanAll {
	[msgStore cleanAll];
	//[msgStore save];
	[tableView reloadData];
}

-(NSInteger) getMsgNum {
	return [msgStore getMsgNum];
}
-(void) refreshMsgList:(id) obj {
	[updateLock lock];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	[msgStore refresh];
	[msgStore save];
	[self performSelectorOnMainThread:@selector(doneLoadingTableViewData:) withObject:nil waitUntilDone:YES];
	[pool release];
	[updateLock unlock];
}

-(void) moreMsgList:(id) obj {
	[updateLock lock];
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int moreNum = [msgStore more];
	[msgStore save];
	NSNumber* number = [NSNumber numberWithInt:moreNum];
	[self performSelectorOnMainThread:@selector(doneLoadingMoreTableViewData:) withObject:number waitUntilDone:YES];
	[pool release];
	[updateLock unlock];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [msgStore getMsgNum];
}

-(CGFloat) tableView:(UITableView *) tableView1 heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	NSDictionary * data = [msgStore getMsgAtIndex:[indexPath row]];
	return [KKMsgListCellView cellHeight:data tableView:tableView1 showReply:(!self.replyHidden)];
}

- (UITableViewCell *) tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* identifier = @"KKMsgListCellView";
	KKMsgListCellView* msgCell = (KKMsgListCellView *) [tableView1 dequeueReusableCellWithIdentifier:identifier];
	if (msgCell == nil) {
		msgCell = [[KKMsgListCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
		UILongPressGestureRecognizer *longPressGR = 
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressGR.minimumPressDuration = 2;
        [msgCell addGestureRecognizer:longPressGR];
        [longPressGR release];
		msgCell.delegate = self;
	}
	msgCell.replyHidden = self.replyHidden;
	[msgCell setData:[msgStore getMsgAtIndex:[indexPath row]] atIndexPath:indexPath imageDelegate:self];
	return msgCell;
}

/*
-(BOOL) shouldUpdateImageView:(NSDictionary *) imageInfo {
	NSString* msgId = [imageInfo objectForKey:@"id"];
	NSIndexPath* indexPath = [imageInfo objectForKey:@"indexPath"];
	if (msgId == nil || indexPath == nil) {
		return NO;
	}
	NSString* type = [imageInfo objectForKey:@"type"];
	NSDictionary* currentData = [msgStore getMsgAtIndex:[indexPath row]];
	if (currentData == nil) {
		return NO;
	}
	
	if (type != nil && [type isEqualToString:@"reply"]) {
		currentData = [currentData objectForKey:@"reply_msg"];
		if (currentData == nil) {
			return NO;
		}
	} 
	
	NSString* currentMsgId = [currentData objectForKey:@"id"];
	if ([currentMsgId isEqualToString:msgId]) {
		// check visible
		if ([tableView cellForRowAtIndexPath:indexPath] != nil) {
			return YES;
		}
	}
	return NO;
}
 */


- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
			if ([delegate respondsToSelector:@selector(msgListView:didLongTouchAt:)]) {
				KKMsgListCellView* view = (KKMsgListCellView *) recognizer.view;
				
				[delegate msgListView:self didLongTouchAt:view.currentIndexPath];
			}
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
        case UIGestureRecognizerStateEnded:
            
            break;
        default:
            break;
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([delegate respondsToSelector:@selector(msgListView:didTouchAt:)]) {
		[delegate msgListView:self didTouchAt:indexPath];
	}
}

-(NSDictionary *) getMsgDataAt:(NSIndexPath *) indexPath {
	return [msgStore getMsgAtIndex:[indexPath row]];
}


-(void) onAuthorImageViewClicked:(NSIndexPath *) indexPath {
	if ([delegate respondsToSelector:@selector(msgListView:didAuthorImageViewClicked:)]) {
		[delegate msgListView:self didAuthorImageViewClicked:indexPath];
	}
}

-(void) setURL:(NSString *) url {
	msgStore.url = url;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (adBanner == nil || showBanner == NO) {
		return 0;
	}
	return GAD_SIZE_320x50.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (showBanner == NO) {
		return nil;
	}
	return adBanner;
}

-(void)adViewDidReceiveAd:(GADBannerView *)bannerView {
	if (showBanner == NO) {
		UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		closeButton.frame = CGRectMake(bannerView.frame.size.width - 25, 5, 20, 20);
		closeButton.backgroundColor = [UIColor clearColor];
		[closeButton addTarget:self action:@selector(closeAd) forControlEvents:UIControlEventTouchUpInside];
		[closeButton setImage:[UIImage imageNamed:@"close_icon.png"] forState:(UIControlStateNormal)];
		[bannerView addSubview:closeButton];
		showBanner = YES;
		[tableView reloadData];
	}
}

-(void) closeAd {
	showBanner = NO;
	[tableView reloadData];
}
@end
