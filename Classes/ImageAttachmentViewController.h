//
//  ImageAttachmentViewController.h
//  obanana
//
//  Created by Wang Jinggang on 11-6-6.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageAttachmentViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UIScrollView* scrollView;
	UIImage* image;
	UIImageView* imageView;
}


-(IBAction) dismissImageDetail:(id) sender;

-(IBAction) deleteImageAttachment:(id) sender;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) UIImage* image;

@end
