//
//  KKDataVersionManager.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-31.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKDataVersionManager : NSObject {
	NSMutableDictionary* versionDict;
	NSString* saveFile;
}

@property(nonatomic, retain) NSMutableDictionary* versionDict;
+(KKDataVersionManager *) getInstance;

-(void) increaseDataVersion;
-(BOOL) shouldUpdate:(NSString*) key;
-(void) updated:(NSString*) key;

-(void) saveVersion;

@end
