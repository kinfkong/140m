//
//  KKIconPageView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKIconPageView.h"
#import "KKIconItem.h"
#import "KKIconView.h"

@implementation KKIconPageView

-(id) initWithFrame:(CGRect) frame iconList:(NSArray *) list {
	self = [super initWithFrame:frame];
	if (self != nil) {
		CGFloat iconWidth = 319 / 3.0;
		CGFloat iconHeight = 346 / 3.0;
		
		NSInteger columnNum = (NSInteger) (frame.size.width / iconWidth);
		if (columnNum <= 0) {
			columnNum = 1;
		}
		NSInteger rowNum = (NSInteger) ((self.frame.size.height - 20) / iconHeight);
		if (rowNum <= 0) {
			rowNum = 1;
		}
		
		NSInteger pageNum = ([list count] + rowNum * columnNum - 1) / (rowNum * columnNum);
		if (pageNum <= 0) {
			pageNum = 1;
		}
		NSLog(@"columnNum:%d, rowNum:%d", columnNum, rowNum);
		//pageNum = 2;
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		//self.backgroundColor = [UIColor yellowColor];
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20)];
		scrollView.backgroundColor = [UIColor grayColor];
		[self addSubview:scrollView];
		
		scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageNum, scrollView.frame.size.height);
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.scrollsToTop = NO;
		scrollView.delegate = self;
		pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
		//[self bringSubviewToFront:pageControl];
		[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		[self addSubview:pageControl];
		
		pageControl.backgroundColor = [UIColor grayColor];
		pageControl.hidesForSinglePage = NO;
		pageControl.numberOfPages = pageNum;
		pageControl.currentPage = 0;
		pageControl.userInteractionEnabled = YES;
		pageControlUsed = NO;
		
		pageControl.currentPage = 1;
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
			KKIconView* view = [[KKIconView alloc] initWithFrame:CGRectMake(
			pageNo * scrollView.frame.size.width + columnNo * iconWidth, rowNo * iconHeight, iconWidth, iconHeight)];
			[view setText:item.text];
			[view setImage:item.image];
			[scrollView addSubview:view];
			[view release];
		}
		
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame iconList:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[scrollView release];
	[pageControl release];
    [super dealloc];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
	//NSLog(@"pageControlUsed:%@", pageControlUsed ? @"yes" : @"no");
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
	NSLog(@"here!!!");
    int page = pageControl.currentPage;
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

@end
