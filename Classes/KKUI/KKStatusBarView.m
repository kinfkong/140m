//
//  KKStatusBarView.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKStatusBarView.h"


@implementation KKStatusBarView

@synthesize label;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor clearColor];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		
		label.backgroundColor = [UIColor colorWithRed:155.0/255.0 green:155.0/255.0 blue:237.0/255.0 alpha:0.6];
		label.textAlignment = UITextAlignmentCenter;
		label.text = @"发送中 ...";
		label.font = [UIFont systemFontOfSize:12];
		[self addSubview:label];
		
		self.hidden = YES;
    }
    return self;
}


-(void) showWithMsg:(NSString*) msg {
	[self setAlpha:1.0f];
	self.hidden = NO;
	label.text = msg;
}

-(void) changeStatus:(NSString *) msg {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:3.0];
	self.label.text = msg;
	[UIView commitAnimations];
	
}

-(void) disappear {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	[self setAlpha:0.0f];
	[UIView commitAnimations];
	// self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[label release];
    [super dealloc];
}


@end
