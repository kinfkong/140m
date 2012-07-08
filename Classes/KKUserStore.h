//
//  KKUserStore.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-25.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKUserStore : NSObject {
	NSMutableArray* userArray;
	NSString* saveFile;
}

-(id) init;
-(void) deleteUser:(NSString *) userName;
-(void) addUser:(NSDictionary *) userInfo;
-(int) getUserNum;
-(NSDictionary*) getUser:(int) index;
@end
