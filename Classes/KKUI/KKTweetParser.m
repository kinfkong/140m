//
//  KKTweetParser.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-28.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKTweetParser.h"

void kkstrcpy(char* des, int dessize, const char* src, int len) {
	int i = 0;
	for (i = 0; i < len && i + 1 < dessize; i++) {
		des[i] = src[i];
	}
	des[i] = 0;
}

@implementation KKTweetNode

@synthesize originalContent;

-(NSString *) displayWithType:(KKTweetDisplayType) displayType {
	//NSLog(@"testing:%@", [NSString stringWithFormat:@"[%@]", self.originalContent]);
	return self.originalContent;
}
@end


@implementation KKTweetTextNode



-(NSString *) displayWithType:(KKTweetDisplayType) displayType {
	if (displayType == KKTweetDisplaySimpleType) {
		NSString* tmp = [self.originalContent stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
		return [tmp stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
	} else if (displayType == KKTweetDisplayRichType) {
		return self.originalContent;
	}
	return self.originalContent;
}

@end

@implementation KKTweetURLNode

-(NSString *) displayWithType:(KKTweetDisplayType) displayType {
	if (displayType == KKTweetDisplaySimpleType) {
		return self.originalContent;
	} else if (displayType == KKTweetDisplayRichType) {
		//return self.originalContent;
		return [NSString stringWithFormat:@"<a href=\"obanana:jumpto:%@\">%@</a>", self.originalContent, self.originalContent];
	}
	return self.originalContent;
}

@end

@implementation KKTweetTopicNode

-(NSString *) displayWithType:(KKTweetDisplayType) displayType {
	if (displayType == KKTweetDisplaySimpleType) {
		return self.originalContent;
	} else if (displayType == KKTweetDisplayRichType) {
		//return self.originalContent;
		// NSLog(@"the topic str: %@",  [NSString stringWithFormat:@"<a href=\"obanana:showtopic:%@\">%@</a>", self.originalContent, self.originalContent]);
		NSRange range;
		range.location = 1;
		range.length = [self.originalContent length] - 2;
		return [NSString stringWithFormat:@"<a href=\"obanana:showtopic:%@\">%@</a>", [self.originalContent substringWithRange:range], self.originalContent];
	}
	return self.originalContent;
}

@end

@implementation KKTweetFaceNode

@end

@implementation KKTweetUserNode

-(NSString *) displayWithType:(KKTweetDisplayType) displayType {

	
	NSArray* array = [self.originalContent componentsSeparatedByString:@"@"];
	if ([array count] != 2) {
		return self.originalContent;
	}
	
	NSString* nick = [array objectAtIndex:0];
	NSString* name = [array objectAtIndex:1];
	nick = [nick substringFromIndex:1];
	name = [name substringToIndex:[name length] - 1];
	
	if (displayType == KKTweetDisplaySimpleType) {
		return nick;
	} else if (displayType == KKTweetDisplayRichType) {
		// <a href="#">王景刚</a><span class="user">(@kkwang)</span>
		return [NSString stringWithFormat:@"<a href=\"obanana:showuserinfo:%@\">%@</a><span class=\"user\">(@%@)</span>", name,nick, name];
	} else if (displayType == KKTweetDisplayEditType) {
		return [NSString stringWithFormat:@"@%@",name];
	}
	return self.originalContent;
}

@end

@implementation KKTweetParser

+(NSArray *) parse:(NSString *) msg {
	NSMutableArray* ans = [[NSMutableArray alloc] init];
	if (msg == nil) {
		return [ans autorelease];
	}
	const char* str = [msg cStringUsingEncoding:NSUTF8StringEncoding];
	char tmpbuf[4096];
	int k = -1;
	
	for (int i = 0;;) {
		int len = 0;
		int type = -1;
		if (str[i] == '<') {
			const char* p = strchr(str + i, '>');
			if (p != NULL) {
				// check
				const char* q = strchr(str + i + 1, '@');
				if (q != NULL && q < p) {
					const char* t = NULL;
					for (t= q + 1; t < p; t++) {
						if (*t != '-' && *t != '_' && !(*t <= 'z' && *t >= 'a') && !(*t <= 'Z' && *t >= 'A') 
							&& !(*t <= '9' && *t >= '0')) {
							break;
						}
					}
					if (t == p) {
						// str + i ... p
						len = p - (str + i) + 1;
						type = 1;
					}
				}
			}
		} else if (str[i] == '#') {
			const char* p = strchr(str + i + 1, '#');
			if (p != NULL) {
				len = p - (str + i) + 1;
				type = 2;
			}
		} else if (str[i] == '[') {
			const char* p = strchr(str + i + 1, ']');
			if (p != NULL) {
				// check face mgr, TODO
				len = p - (str + i) + 1;
				type = 3;
			}
		} else if (strncmp(str + i, "http://", strlen("http://")) == 0) {
			const char* p = str + i;
			while (*p != 0 && (*p & 0x80) == 0 && *p != ' ' && *p != '\t' && *p != '\r' && *p != '\n') {
				p++;
			}
			len = p - (str + i);
			type = 4;
		}
		
		if (len > 0 || str[i] == 0x00) {
			if (k >= 0) {
				KKTweetNode* node = [[KKTweetTextNode alloc] init];
				kkstrcpy(tmpbuf, sizeof(tmpbuf), str + k, i - k);
				node.originalContent = [NSString stringWithUTF8String:tmpbuf];
				[ans addObject:node];
				[node release];
			}
			k = -1;
		}
		
		
		if (str[i] == 0x00) {
			break;
		}
		
		if (len > 0) {
			KKTweetNode* node = nil;
			if (type == 1) {
				node = [[KKTweetUserNode alloc] init];
			} else if (type == 2) {
				node = [[KKTweetTopicNode alloc] init];
			} else if (type == 3) {
				node = [[KKTweetFaceNode alloc] init];
			} else if (type == 4) {
				node = [[KKTweetURLNode alloc] init];
			}
			kkstrcpy(tmpbuf, sizeof(tmpbuf), str + i, len);
			node.originalContent = [NSString stringWithUTF8String:tmpbuf];
			[ans addObject:node];
			[node release];
			
			i += len;
		} else {
			if (k < 0) {
				k = i;
			}
			i++;
		}
		
	}
	
	return [ans autorelease];
}

+(NSString *) display:(NSString*) msg withDisplayType:(KKTweetDisplayType) displayType {
	NSArray* nodes = [KKTweetParser parse:msg];
	NSMutableString* res = [[NSMutableString alloc] init];
	for (KKTweetNode * node in nodes) {
		[res appendString:[node displayWithType:displayType]];
	}
	return [res autorelease];
}

@end
