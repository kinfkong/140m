//
//  KKImageScrollView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-1.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKImageScrollView.h"
#import "UIImageView+ASYNC.h"


@implementation KKImageScrollView


- (id)initWithFrame:(CGRect)frame imageId:(NSString*) imageId {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		scrollView = [[UIScrollView alloc] initWithFrame:frame];
		scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		scrollView.backgroundColor = [UIColor blackColor];
		scrollView.delegate = self;
		[self addSubview:scrollView];
		
		
		imageView = [[UIImageView alloc] initWithFrame:frame];
		[scrollView addSubview:imageView];
		
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/pic/%@/2000", imageId];
		[imageView loadImageWithURL:url tmpImage:nil cache:YES delegate:self withObject:nil];
		
		activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24.f, 24.f)]; 
		[activityIndicator setCenter:CGPointMake(scrollView.bounds.size.width / 2, 
												 scrollView.bounds.size.height / 2)]; 
		[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		[scrollView addSubview:activityIndicator];
		[activityIndicator startAnimating];
		
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[activityIndicator release];
	[imageView release];
	[scrollView release];
    [super dealloc];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return imageView;
}

-(void) finishedLoadWithImage:(UIImage *) image {
	[activityIndicator stopAnimating];
	imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
	scrollView.contentSize = CGSizeMake(image.size.width, image.size.height);
	float scale1 = scrollView.frame.size.width / image.size.width;
	float scale2 = scrollView.frame.size.height / image.size.height;
	float scale = scale1 < scale2 ? scale1 : scale2;
	if (scale > 1) {
		scale = 1;
	}
	//NSLog(@"the scale:%lf", scale);
	scrollView.maximumZoomScale = 2;
	scrollView.minimumZoomScale = scale;
	// scrollView.zoomScale = scale;
	[scrollView setZoomScale:scale animated:NO];
}

@end
