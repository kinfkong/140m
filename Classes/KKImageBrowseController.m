    //
//  KKImageBrowseController.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-1.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKImageBrowseController.h"
#import "KKImageScrollView.h"


@implementation KKImageBrowseController

@synthesize imageId;

-(id) initWithImageId:(NSString*) _imageId {
	self = [super init];
	if (self != nil) {
		self.imageId = _imageId;
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
	self.title = @"查看图片";
	CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	KKImageScrollView* imageScrollView = [[KKImageScrollView alloc] initWithFrame:frame imageId:self.imageId];
	[self.view addSubview:imageScrollView];
	[imageScrollView release];
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
	[imageId release];
    [super dealloc];
}


@end
