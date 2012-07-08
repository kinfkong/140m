    //
//  RegisterController.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import "RegisterController.h"
#import "ConfigModel.h"

#import "obananaViewController.h"
#import "UserModel.h"
#import "KKLoginController.h"


@implementation RegisterController

@synthesize registerWebView;
@synthesize delegate;

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
	NSURL* url = [[ NSURL alloc ] initWithString :[[ConfigModel getInstance] getRegisterPageURL]];
	[registerWebView loadRequest:[NSURLRequest requestWithURL: url]];
	[url release];
	self.registerWebView.delegate = self;
	 
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24.f, 24.f)]; 
	[activityIndicator setCenter:CGPointMake(registerWebView.bounds.size.width / 2, 
											 registerWebView.bounds.size.height / 2)]; 
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[registerWebView addSubview:activityIndicator];
}

-(IBAction)dismiss:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
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
	[activityIndicator release];
	[delegate release];
    [super dealloc];
}


//开始加载数据
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[activityIndicator startAnimating];   
}

//数据加载完   
- (void)webViewDidFinishLoad:(UIWebView *)webView {   
	[activityIndicator stopAnimating];
} 

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[activityIndicator stopAnimating];
	NSString* errorMsg = @"网络连接失败";
	UIAlertView* av = [[[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[av show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType {
	NSString *requestString = [[request URL] absoluteString];	
	NSArray *components = [requestString componentsSeparatedByString:@":"];
	if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"obanana"]) {
		if([components count] == 4 && [(NSString *)[components objectAtIndex:1] isEqualToString:@"gofrontpage"]) {
			NSString* name = [components objectAtIndex:2];
			NSString* token = [components objectAtIndex:3];
			if (delegate != nil && [delegate respondsToSelector:@selector(afterRegister:token:)]) {
				[delegate afterRegister:name token:token];
			}
		}		
		return NO;	
	} 	
	return YES;
}


@end
