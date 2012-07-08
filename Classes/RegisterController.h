//
//  RegisterController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-2.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterControllerDelegate;


@interface RegisterController : UIViewController <UIWebViewDelegate>  {
	IBOutlet UIWebView* registerWebView;
	UIActivityIndicatorView* activityIndicator;
	id<RegisterControllerDelegate> delegate;
}

@property(nonatomic, retain) id<RegisterControllerDelegate> delegate;

-(IBAction)dismiss:(id)sender;


@property (nonatomic, retain) IBOutlet UIWebView* registerWebView;

@end

@protocol RegisterControllerDelegate <NSObject>

-(void) afterRegister:(NSString*) name token:(NSString*) token;

@end



