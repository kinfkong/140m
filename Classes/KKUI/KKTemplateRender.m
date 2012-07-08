//
//  KKTemplateRender.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-29.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKTemplateRender.h"



// statement1: <?kk $abc ?>
// statement2: <?kk if ($abc == "efg") ?> // NSString
// statement5: <?kk endif ?>




@implementation KKTemplateRender

+(NSString*) clearVar:(NSString *) var {
	if ([var characterAtIndex:0] == '\"') {
		var = [var substringFromIndex:1];
	}
	if ([var characterAtIndex:[var length] - 1] == '\"') {
		var = [var substringToIndex:[var length] - 1];
	}
	return var;
}

+(id) findAssignment:(NSString *) var withData:(NSDictionary *) data {
	var = [var substringFromIndex:1];
	var = [data objectForKey:var];
	return var;
}

+(BOOL) isVar:(NSString *) var {
	if ([var characterAtIndex:0] == '$') {
		return YES;
	}
	return NO;
}

+(BOOL) evalStatement:(NSString*) statement withData:(NSDictionary *) data {
	// $abc == "efg"
	// $abc == 1
	NSArray* kv = [statement componentsSeparatedByString:@"=="];
	if ([kv count] != 2) {
		return FALSE;
	}
	
	id var1 = [kv objectAtIndex:0];
	id var2 = [kv objectAtIndex:1];
	var1 = [var1 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	var2 = [var2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	var1 = [KKTemplateRender clearVar:var1];
	var2 = [KKTemplateRender clearVar:var2];
	
	if ([KKTemplateRender isVar:var1]) {
		var1 = [KKTemplateRender findAssignment:var1 withData:data];
	}
	
	if ([KKTemplateRender isVar:var2]) {
		var2 = [KKTemplateRender findAssignment:var2 withData:data];
	}
	
	if (var1 == nil || var2 == nil) {
		return NO;
	}
	
	if ([var1 isKindOfClass:[NSNumber class]]) {
		var1 = [(NSNumber *) var1 stringValue];
	}
	if ([var2 isKindOfClass:[NSNumber class]]) {
		var2 = [(NSNumber *) var2 stringValue];
	}
	return [(NSString *) var1 isEqualToString:(NSString *) var2];
}


+(NSString *) renderNodes:(NSArray *) nodes low:(int) low high:(int) high withData:data {
	if (low >  high) {
		return @"";
	}
	NSDictionary* node = [nodes objectAtIndex:low];
	NSString* type = [node objectForKey:@"type"];
	if ([type isEqualToString:@"text"]) {
		NSString* content = [node objectForKey:@"content"];
		NSString* res = [KKTemplateRender renderNodes:nodes low:low + 1 high:high withData:data];
		if (res == nil) {
			return nil;
		}
		return [NSString stringWithFormat:@"%@%@", content, res];
	}
	
	if ([type isEqualToString:@"assign"]) {
		NSString* var = [node objectForKey:@"var"];
		NSString* res = [KKTemplateRender renderNodes:nodes low:low + 1 high:high withData:data];
		if (res == nil) {
			return nil;
		}
		return [NSString stringWithFormat:@"%@%@", [KKTemplateRender findAssignment:var withData:data], res];
	}
	
	if (![type isEqualToString:@"if"]) {
		NSLog(@"should begin with if.");
		return nil;
	}
	int c = 0;
	NSMutableArray* branchesLocation = [[[NSMutableArray alloc] init] autorelease];
	for (int i = low; i <= high; i++) {
		NSDictionary* tnode = [nodes objectAtIndex:i];
		NSString* ttype = [tnode objectForKey:@"type"];
		if ([ttype isEqualToString:@"if"]) {
			c++;
			if (c == 1) {
				[branchesLocation addObject:[NSNumber numberWithInt:i]];
			}
		} else if ([ttype isEqualToString:@"else if"]) {
			if (c == 1) {
				[branchesLocation addObject:[NSNumber numberWithInt:i]];
			}
		} else if ([ttype isEqualToString:@"else"]) {
			if (c == 1) {
				[branchesLocation addObject:[NSNumber numberWithInt:i]];
			}
		} else if ([ttype isEqualToString:@"endif"]) {
			if (c == 1) {
				[branchesLocation addObject:[NSNumber numberWithInt:i]];
			}
			c--;
			if (c == 0) {
				break;
			}
		}
	}
	
	if (c != 0) {
		NSLog(@"failed to match the if and endif.");
		return nil;
	}
	
	NSString* block = @"";
	for (int i = 0; i < [branchesLocation count]; i++) {
		NSDictionary* tnode = [nodes objectAtIndex:[[branchesLocation objectAtIndex:i] intValue]];
		NSString* ttype = [tnode objectForKey:@"type"];
		NSString* statement = [tnode objectForKey:@"statement"];
		if ([ttype isEqualToString:@"if"]) {
			if (i != 0) {
				NSLog(@"Invaid place of if.");
				return nil;
			}
		} else if ([ttype isEqualToString:@"else if"]) {
			if (i == 0 || i == [branchesLocation count] - 1) {
				NSLog(@"Invalid place of else if");
				return nil;
			}
		} else if ([ttype isEqualToString:@"else"]) {
			if (i != [branchesLocation count] - 2) {
				NSLog(@"Invalid place of else");
				return  nil;
			}
		} else { // @"endif"
			if (i != [branchesLocation count] - 1) {
				NSLog(@"invalid place of endif. expected:%d current:%d", [branchesLocation count] - 1, i);
				return nil;
			}
			break;
		}
		
		if (statement == nil || [KKTemplateRender evalStatement:statement withData:data]) {
			int newhigh = [[branchesLocation objectAtIndex:i + 1] intValue];
			block = [KKTemplateRender renderNodes:nodes low:[[branchesLocation objectAtIndex:i] intValue] + 1 high:newhigh - 1 withData:data];
			if (block == nil) {
				return nil;
			}
			break;
		}
	}
	int newlow = [[branchesLocation objectAtIndex:[branchesLocation count] - 1] intValue] + 1;
	NSString* other = [KKTemplateRender renderNodes:nodes low:newlow high:high withData:data];
	if (other == nil) {
		return nil;
	}
	return [NSString stringWithFormat:@"%@%@", block, other];
}

+(NSDictionary *) parseTagNode:(NSString *) page {
	NSMutableDictionary* node = [[[NSMutableDictionary alloc] init] autorelease];
	NSArray* types = [NSArray arrayWithObjects:@"if",@"else if",@"else",@"endif",nil];
	for (NSString* type in types) {
		NSString* prefix = [NSString stringWithFormat:@"<?kk %@ ", type];
		if ([page hasPrefix:prefix]) {
			[node setObject:type forKey:@"type"];
			if ([type isEqualToString:@"if"] || [type isEqualToString:@"else if"]) {
				// add statement
				NSString* statement = [page substringFromIndex:[prefix length]];
				if ([statement hasSuffix:@"?>"]) {
					statement = [statement substringToIndex:[statement length] - 1 - [@"?>" length]]; 
				}
				statement = [statement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
				if ([statement hasPrefix:@"("]) {
					statement = [statement substringFromIndex:1];
				}
				if ([statement hasSuffix:@")"]) {
					statement = [statement substringToIndex:[statement length] - 1 - 1];
				}
				[node setObject:statement forKey:@"statement"];
			}
			return node;
		}
	}
	
	[node setObject:@"assign" forKey:@"type"];
	NSString* var = [page substringFromIndex:4]; // <?kk
	var = [var substringToIndex:[var length] - 1 - 2]; // ?>
	var = [var stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	[node setObject:var forKey:@"var"];
	return node;
}

+(NSArray *) parse:(NSString *) pageTemplate {
	const char* page = [pageTemplate cStringUsingEncoding:NSUTF8StringEncoding];
	if (page == nil) {
		return nil;
	}
	const char* p = page;
	int len = 0;
	NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
	while (YES) {
		const char* q = strstr(p, "<?kk");
		if (q == NULL) {
			len = strlen(p);
		} else {
			len = q - p;
		}
		
		// add the text node
		NSMutableDictionary* node = [[NSMutableDictionary alloc] init];
		[array addObject:node];
		[node release];
		
		[node setObject:@"text" forKey:@"type"];
		NSString* content = [[NSString alloc] initWithBytes:p length:len encoding:NSUTF8StringEncoding];
		[node setObject:content forKey:@"content"];
		[content release];
		
		if (q == NULL) {
			break;
		}
		
		const char* q1 = strstr(q, "?>");
		if (q1 == NULL) {
			return nil;
		}
		NSDictionary* node2 = [KKTemplateRender parseTagNode:[NSString stringWithFormat:@"%.*s", q1 - q + 2, q]];
		if (node2 == nil) {
			return nil;
		}
		[array addObject:node2];
		
		p = q1 + 2;
		
	}
	return array;
}

+(NSString *) render:(NSString *) pageTemplate withData:(NSDictionary *) data {
	NSArray* nodes = [KKTemplateRender parse:pageTemplate];
	if (nodes == nil) {
		return nil;
	}
	return [KKTemplateRender renderNodes:nodes low:0 high:[nodes count] - 1 withData:data];
}

@end
