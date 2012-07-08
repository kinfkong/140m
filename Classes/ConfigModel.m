//
//  ConfigModel.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-3.
//  Copyright 2011 tencent. All rights reserved.
//

#import "ConfigModel.h"


@implementation ConfigModel

static NSString* OBANANA_BASE_URL = @"http://m.obanana.com/index.php/";

static ConfigModel* instance = nil;

+(ConfigModel *) getInstance {
	if (instance == nil) {
		instance = [[ConfigModel alloc] init];
	}
	return instance;
}

-(NSString *) getRegisterPageURL {
	return [NSString stringWithFormat:@"%@%@", OBANANA_BASE_URL, @"user/showmobileregister"];
}

-(NSString *) getMsgPostURL {
	return [NSString stringWithFormat:@"%@%@", OBANANA_BASE_URL, @"post/up"];
}

@end
