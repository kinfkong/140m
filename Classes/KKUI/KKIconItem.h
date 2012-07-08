//
//  KKIconItem.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-24.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKIconItem : NSObject {
	NSString* text;
	UIImage* image;
	id target;
	SEL action;
}

@property (retain, nonatomic) NSString* text;
@property (retain, nonatomic) UIImage* image;
@property (retain, nonatomic) id target;
@property (assign) SEL action;

-(id) initWithText:(NSString *) text image:(UIImage *) image target:(id) target action:(SEL) action;

@end
