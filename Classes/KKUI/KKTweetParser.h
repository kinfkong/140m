//
//  KKTweetParser.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-28.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	KKTweetDisplayRichType,
	KKTweetDisplaySimpleType,
	KKTweetDisplayEditType,
} KKTweetDisplayType;

@interface KKTweetNode : NSObject {
	NSString* originalContent;
}

@property (nonatomic, retain) NSString* originalContent;
-(NSString *) displayWithType:(KKTweetDisplayType) displayType;
@end

@interface KKTweetTextNode : KKTweetNode {
}
@end

@interface KKTweetURLNode : KKTweetNode {
}
@end

@interface KKTweetTopicNode : KKTweetNode {
}
@end

@interface KKTweetUserNode : KKTweetNode {
}
@end

@interface KKTweetFaceNode : KKTweetNode {
}
@end

@interface KKTweetParser : NSObject {

}

+(NSArray *) parse:(NSString *) msg;

+(NSString *) display:(NSString*) msg withDisplayType:(KKTweetDisplayType) displayType;

@end
