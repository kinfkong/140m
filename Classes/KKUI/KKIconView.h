//
//  KKIconView.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-23.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKIconView : UIView {
	UIImageView* imageView;
	UILabel* label;
}

-(void) setImage:(UIImage *) image;

-(void) setText:(NSString *) text;

@end
