//
//  ImageAttachmentViewController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-6.
//  Copyright 2011 tencent. All rights reserved.
//

#import "ImageAttachmentViewController.h"

#import "ComposeMsgController.h"


@implementation ImageAttachmentViewController


@synthesize scrollView;
@synthesize image;

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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGRect frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
	imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image = self.image;
	//imageView.center = CGPointMake(scrollView.bounds.size.width / 2, scrollView.bounds.size.height / 2);
	scrollView.contentSize = CGSizeMake(self.image.size.width, self.image.size.height);
	[scrollView setMaximumZoomScale:2.0];
	float minScale = scrollView.frame.size.height / self.image.size.height;
	[scrollView setMinimumZoomScale:minScale];
	[scrollView addSubview:imageView];
	scrollView.backgroundColor = [UIColor blackColor];
	[imageView release];
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

-(UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)dealloc {
	[imageView release];
    [super dealloc];
}

-(IBAction) dismissImageDetail:(id) sender {
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(IBAction) deleteImageAttachment:(id) sender {
	[(ComposeMsgController *) self.parentViewController removeImageAttachement];
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end
