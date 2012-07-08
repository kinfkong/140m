//
//  KKWebBrowserController.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-6.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKWebBrowserController : UIViewController {
	UIWebView* web;
	NSString* url;
}

@property (nonatomic, retain) NSString* url;

-(id) initWithBaseURL:(NSString *) _url;

@end
