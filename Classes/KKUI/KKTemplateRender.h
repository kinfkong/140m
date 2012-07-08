//
//  KKTemplateRender.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-29.
//  Copyright 2011 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKTemplateRender : NSObject {

}

+(NSString *) render:(NSString *) pageTemplate withData: (NSDictionary *) data;

@end
