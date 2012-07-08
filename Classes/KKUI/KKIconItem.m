//
//  KKIconItem.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKIconItem.h"


@implementation KKIconItem

@synthesize text;
@synthesize image;
@synthesize target;
@synthesize action;


-(id) initWithText:(NSString *) _text image:(UIImage *) _image target:(id) _target action:(SEL) _action {
	self = [super init];
	if (self != nil) {
		self.text = _text;
		self.image = _image;
		self.target = _target;
		self.action = _action;
	}
	return self;
}

-(void) dealloc {
	[text release];
	[image release];
	[target release];
	[super dealloc];
}

@end
