//
//  KKMsgListCellView.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-26.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKMsgListCellView.h"
#import "UtilModel.h"
#import "UIImageView+ASYNC.h"
#import <QuartzCore/QuartzCore.h>
#import "KKTweetParser.h"
#import "UserModel.h"

#define KKMSGLABLE_ORIGIN (CGPointMake(63, 35))
#define KKMSGLABLE_FONT ([UIFont systemFontOfSize:16.0f])
#define KKMSGLABLE_TOTAL_MARGIN (63 + 8)
#define KKIMAGEVIEW_SIZE (CGSizeMake(90, 90))
#define KKREPLYMSG_WIDTH ((320 - KKMSGLABLE_TOTAL_MARGIN) - 3)

@implementation KKMsgListCellView

@synthesize currentIndexPath;
@synthesize replyHidden;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		CGFloat  currentY = 10;
		self.replyHidden = NO;
		
		CGRect frame = CGRectMake(63, currentY, self.frame.size.width - KKMSGLABLE_TOTAL_MARGIN, 18);
		authorNameLabel = [[UILabel alloc] initWithFrame:frame];
		authorNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
		authorNameLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:authorNameLabel];
		
		timeLabel = [[UILabel alloc] initWithFrame:frame];
		timeLabel.font = [UIFont systemFontOfSize:13.0f];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.textAlignment = UITextAlignmentRight;
		timeLabel.textColor = [UIColor grayColor];
		[self.contentView addSubview:timeLabel];
		
		currentY += 25;
		frame = CGRectMake(63, currentY, self.frame.size.width - KKMSGLABLE_TOTAL_MARGIN, 18);
		msgLabel = [[UILabel alloc] initWithFrame:frame];
		msgLabel.font = KKMSGLABLE_FONT;
		msgLabel.numberOfLines = 0;
		msgLabel.lineBreakMode = UILineBreakModeWordWrap;
		[self.contentView addSubview:msgLabel];
		currentY += 20;
		
		frame = CGRectMake(63, currentY, KKIMAGEVIEW_SIZE.width, KKIMAGEVIEW_SIZE.height);
		imageView = [[UIImageView alloc] initWithFrame:frame];
		[self.contentView addSubview:imageView];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.hidden = YES;
		
		currentY += KKIMAGEVIEW_SIZE.height + 5;
		frame = CGRectMake(63, currentY, KKREPLYMSG_WIDTH, 18);
		currentY += 20;
		replyView = [[KKMsgListReplyView alloc] initWithFrame:frame];
		replyView.hidden = YES;
		[self.contentView addSubview:replyView];
		
		comeFromLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:comeFromLabel];
		fromLocationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:fromLocationLabel];
		
		// author image
		frame = CGRectMake(3, 10, 50, 50);
		authorImageView = [[UIImageView alloc] initWithFrame:frame];
		[self.contentView addSubview:authorImageView];
		authorImageView.layer.masksToBounds = YES;
		authorImageView.layer.cornerRadius = 4.0;
		authorImageView.layer.borderWidth = 0.0;
		authorImageView.layer.borderColor = [[UIColor clearColor] CGColor];
		
		authorImageView.userInteractionEnabled = YES;
		UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAuthorImageViewClicked:)];
		[authorImageView addGestureRecognizer:singleTap];
		[singleTap release];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


+(CGFloat) cellHeight:(NSDictionary *) data tableView: (UITableView *) tableView showReply:(BOOL) showReply {
	NSString* msg = [KKTweetParser display:[data objectForKey:@"msg"] withDisplayType:KKTweetDisplaySimpleType];
	NSString* imageId = [data objectForKey:@"image_id"];
	CGFloat currentY = KKMSGLABLE_ORIGIN.y;
	CGFloat msgheight = [msg sizeWithFont:KKMSGLABLE_FONT
						constrainedToSize:CGSizeMake(tableView.frame.size.width - KKMSGLABLE_TOTAL_MARGIN, MAXFLOAT) 
							lineBreakMode:UILineBreakModeWordWrap].height;
	currentY += msgheight;
	
	if (imageId != nil) {
		currentY += 0;
		currentY += KKIMAGEVIEW_SIZE.height;
	}
	
	NSDictionary* replyMsg = [data objectForKey:@"reply_msg"];
	if (replyMsg != nil && imageId == nil && showReply) {
		currentY += 10;
		currentY += [KKMsgListReplyView viewHeight:replyMsg];
	}
	
	NSString* comeFrom = [data objectForKey:@"fromlocation"];
	if (comeFrom != nil && ![comeFrom isEqualToString:@""]) {
		currentY += 10;
		currentY += 15;
	}
	
	if (currentY < 70) {
		currentY = 70;
	}
	currentY += 10;
	return currentY;
}

-(void) setData: (NSDictionary *) data atIndexPath:(NSIndexPath *) indexPath imageDelegate:(id<UIImageViewAsyncDelegate>) viewdelegate {
	self.currentIndexPath = indexPath;
	authorNameLabel.text = [data objectForKey:@"user_nick"];
	
	if ([data objectForKey:@"to_user"] != nil && [data objectForKey:@"to_user_nick"] != nil && [[data objectForKey:@"user_name"] isEqualToString:[[UserModel getInstance] getUserName]]) {
		authorNameLabel.text = [NSString stringWithFormat:@"发送给 %@", [data objectForKey:@"to_user_nick"]];
	}
	
	NSString* date1 = [data objectForKey:@"create_time"];
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* date2 =  [formatter stringFromDate:[NSDate date]];
	[formatter release];
	timeLabel.text = [[UtilModel getInstance] getReadableDateDiffBetweenDate1:date1 andDate2:date2];
	
	NSString* msg = [KKTweetParser display:[data objectForKey:@"msg"] withDisplayType:KKTweetDisplaySimpleType];
	CGFloat msgheight = [msg sizeWithFont:msgLabel.font
						constrainedToSize:CGSizeMake(msgLabel.frame.size.width, MAXFLOAT) 
						lineBreakMode:UILineBreakModeWordWrap].height;
	
	CGFloat currentY = msgLabel.frame.origin.y;
	CGFloat currentX = msgLabel.frame.origin.x;
	msgLabel.frame = CGRectMake(currentX, currentY, msgLabel.frame.size.width, msgheight);
	msgLabel.text = msg;
	currentY += msgheight;

	
	NSString* imageId = [data objectForKey:@"image_id"];
	if (imageId == nil) {
		imageView.hidden = YES;
	} else {
		imageView.hidden = NO;
		currentY += 0;
		imageView.frame = CGRectMake(currentX, currentY, KKIMAGEVIEW_SIZE.width, KKIMAGEVIEW_SIZE.height);
		currentY += KKIMAGEVIEW_SIZE.height;
		NSString* msgId = [data objectForKey:@"id"];
		NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgId, @"id", indexPath, @"indexPath", nil];
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/pic/%@/160", imageId];
		[imageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:viewdelegate withObject:imageInfo];
	}
	
	NSDictionary* replyMsg = [data objectForKey:@"reply_msg"];
	if (replyMsg == nil || imageId != nil || self.replyHidden == YES) {
		replyView.hidden = YES;
	} else {
		replyView.hidden = NO;
		CGFloat replyViewHeight = [KKMsgListReplyView viewHeight:replyMsg];
		currentY += 10;
		replyView.frame = CGRectMake(currentX, currentY, msgLabel.frame.size.width, replyViewHeight);
		[replyView setData:replyMsg atIndexPath:indexPath imageDelegate:viewdelegate];
		currentY += replyViewHeight;
	}
	
	NSString* comeFrom = [data objectForKey:@"fromlocation"];
	/*
	if (comeFrom == nil || [comeFrom isEqualToString:@""]) {
		comeFrom = @"140m";
	}*/
	if (comeFrom != nil && ![comeFrom isEqualToString:@""]) {
		comeFromLabel.hidden = NO;
		fromLocationLabel.hidden = NO;
		currentY += 10;
		comeFromLabel.frame = CGRectMake(currentX, currentY, msgLabel.frame.size.width, 15);
		fromLocationLabel.frame = CGRectMake(currentX + 30, currentY, msgLabel.frame.size.width - 50, 15);
		currentY += comeFromLabel.frame.size.height;
		comeFromLabel.font = [UIFont systemFontOfSize:13];
		comeFromLabel.textColor = [UIColor grayColor];
		comeFromLabel.text = [NSString stringWithFormat:@"来自"];
		fromLocationLabel.font = comeFromLabel.font;
		fromLocationLabel.textColor = [UIColor grayColor];
		
		if ([comeFrom isEqualToString:@"##system:140m##"]) {
			comeFrom = @"140m";
		} else if ([comeFrom isEqualToString:@"##system:nearby##"]) {
			comeFrom = @"附近";
		}
		fromLocationLabel.text = comeFrom;
	} else {
		comeFromLabel.hidden = YES;
		fromLocationLabel.hidden = YES;
	}
	
	// update the author image view
	NSString* msgId = [data objectForKey:@"id"];
	NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgId, @"id", indexPath, @"indexPath", nil];
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [data objectForKey:@"head_image_id"]];
	[authorImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:viewdelegate withObject:imageInfo];
}


-(void) onAuthorImageViewClicked:(id) sender {
	if ([delegate respondsToSelector:@selector(onAuthorImageViewClicked:)]) {
		[delegate onAuthorImageViewClicked:self.currentIndexPath];
	}
}

- (void)dealloc {
	[delegate release];
	[imageView release];
	[authorImageView release];
	[authorNameLabel release];
	[timeLabel release];
	[msgLabel release];
	[comeFromLabel release];
	[replyNumLabel release];
	[replyView release];
	[currentIndexPath release];
	[fromLocationLabel release];
    [super dealloc];
}



@end

#define KKREPLYMSG_FONT ([UIFont systemFontOfSize:15.0f])

@implementation KKMsgListReplyView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.layer.masksToBounds = YES;
		self.layer.cornerRadius = 2.0;
		self.layer.borderWidth = 1.0;
		self.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1] CGColor];
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.06];
		msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, frame.size.width, 18)];
		msgLabel.backgroundColor = [UIColor clearColor];
		msgLabel.font = KKREPLYMSG_FONT;
		msgLabel.numberOfLines = 0;
		msgLabel.lineBreakMode = UILineBreakModeWordWrap;
		[self addSubview:msgLabel];
		
		
		frame = CGRectMake(3, 18 + 5, KKIMAGEVIEW_SIZE.width, KKIMAGEVIEW_SIZE.height);
		imageView = [[UIImageView alloc] initWithFrame:frame];
		[self addSubview:imageView];
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.hidden = YES;
		
	}
    return self;
}

-(void) dealloc {
	[msgLabel release];
	[imageView release];
	[super dealloc];
}

+(CGFloat) viewHeight:(NSDictionary *) data {
	NSString* msg = [KKTweetParser display:[[UtilModel getInstance] getReplyMsg:data] withDisplayType:KKTweetDisplaySimpleType];
	CGFloat currentY = 3;
	CGFloat msgheight = [msg sizeWithFont:KKREPLYMSG_FONT
						constrainedToSize:CGSizeMake(KKREPLYMSG_WIDTH, MAXFLOAT) 
							lineBreakMode:UILineBreakModeWordWrap].height;
	currentY += msgheight;
	NSString* imageId = [data objectForKey:@"image_id"];
	if (imageId != nil) {
		currentY += 0;
		currentY += KKIMAGEVIEW_SIZE.height;
	}
	currentY += 10;
	return currentY;
}


-(void) setData: (NSDictionary *) data atIndexPath:(NSIndexPath *) indexPath imageDelegate:(id<UIImageViewAsyncDelegate>) delegate {
	NSString* msg = [KKTweetParser display:[[UtilModel getInstance] getReplyMsg:data] withDisplayType:KKTweetDisplaySimpleType];
	CGFloat msgheight = [msg sizeWithFont:KKREPLYMSG_FONT
						constrainedToSize:CGSizeMake(KKREPLYMSG_WIDTH, MAXFLOAT) 
							lineBreakMode:UILineBreakModeWordWrap].height;
	CGFloat currentY = 3;
	msgLabel.frame = CGRectMake(3, currentY, KKREPLYMSG_WIDTH, msgheight);
	msgLabel.text = msg;
	currentY += msgheight;
	
	NSString* imageId = [data objectForKey:@"image_id"];
	if (imageId == nil) {
		imageView.hidden = YES;
	} else {
		imageView.hidden = NO;
		currentY += 0;
		imageView.frame = CGRectMake(3, currentY, KKIMAGEVIEW_SIZE.width, KKIMAGEVIEW_SIZE.height);
		
		NSString* msgId = [data objectForKey:@"id"];
		NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgId, @"id", indexPath, @"indexPath", @"reply", @"type", nil];
		NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/pic/%@/160", imageId];
		[imageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:delegate withObject:imageInfo];
	}
}



@end

