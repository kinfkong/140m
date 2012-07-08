//
//  KKMsgBoxStore.h
//  obanana
//
//  Created by Wang Jinggang on 11-8-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKMsgBoxStore : NSObject {
	NSMutableArray* msgArray;
	NSString* saveFile;
}

-(id) init;

-(void) deleteMsg:(NSString *) msgId;

-(void) addMsg:(NSDictionary *) msgData;

-(int) getMsgNum;

-(NSDictionary*) getMsg:(int) index;

@end
