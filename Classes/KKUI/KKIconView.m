//
//  KKIconView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-23.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKIconView.h"


@implementation KKIconView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		imageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 54) / 2.0, (frame.size.height - 54 - 15) / 2.0, 54, 54)];
		[self addSubview:imageView];
		
		label = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 60) / 2.0, (frame.size.height - 54 - 15) / 2.0 + 54, 60, 15)];
		[self addSubview:label];
		
		//imageView.image = [UIImage imageNamed:@"users.png"];
		
		label.font = [UIFont boldSystemFontOfSize:14];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		label.textColor = [UIColor blackColor];
		
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
	[imageView release];
	[label release];
    [super dealloc];
}


-(void) setImage:(UIImage *) image {
	imageView.image = image;
}

-(void) setText:(NSString *) text {
	label.text = text;
}

@end
