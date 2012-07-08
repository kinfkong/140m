//
//  KKUserProfileView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-4.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKUserProfileView.h"
#import "UIImageView+ASYNC.h"


@implementation KKUserProfileView

@synthesize userInfo;


-(id) initWithUserInfo:(NSDictionary *) _userInfo andFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.userInfo = [NSMutableDictionary dictionaryWithDictionary:_userInfo];
		
		// the header image
		UIImageView* authorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [self.userInfo objectForKey:@"head_image_id"]];
		[authorImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:nil];
		[self addSubview:authorImageView];
		[authorImageView release];
		
		
		
		
    }
    return self;
	
}

- (id)initWithFrame:(CGRect)frame {
	return [self initWithUserInfo:nil andFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[userInfo release];
    [super dealloc];
}


@end
