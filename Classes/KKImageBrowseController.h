//
//  KKImageBrowseController.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-1.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKImageBrowseController : UIViewController {
	NSString* imageId;
}

@property(nonatomic, retain) NSString* imageId;

-(id) initWithImageId:(NSString*) imageId;

@end
