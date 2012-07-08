//
//  KKLocationListView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-14.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKLocationListView.h"
#import "UserModel.h"


@implementation KKLocationListView


@synthesize locationListDelegate;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame delegate:self];
    if (self) {
		//[self refresh];
        // Initialization code.
		/*
		 UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40) ];
		 label.text = @"This is the user list ...";
		 [self addSubview:label];
		 [label release];
		 */
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code.
 }
 */

- (void)dealloc {
	[locationListDelegate release];
    [super dealloc];
}


-(CGFloat) cellHeight:(NSDictionary *) data tableView:(UITableView *) _tableView {
	return 120;
}

-(UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *) data {
	static NSString* identifier = @"KKLocationListView";
	UITableViewCell* msgCell = (UITableViewCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
	if (msgCell == nil) {
		msgCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
		UIImageView* locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 110, 110)];
		locationImageView.tag = 321;
		[msgCell addSubview:locationImageView];
		[locationImageView release];
		
		locationImageView.layer.masksToBounds = YES;
		locationImageView.layer.cornerRadius = 4.0;
		locationImageView.layer.borderWidth = 0.0;
		locationImageView.layer.borderColor = [[UIColor clearColor] CGColor];
		locationImageView.userInteractionEnabled = YES;
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(120, 15, 320 - 120, 25)];
		label.font = [UIFont boldSystemFontOfSize:16.0f];
		label.tag = 100;
		[msgCell addSubview:label];
		[label release];
		
		UILabel* namelabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 320 - 120, 20)];
		namelabel.font = [UIFont systemFontOfSize:18.0f];
		namelabel.tag = 101;
		namelabel.textColor = [UIColor grayColor];
		[msgCell addSubview:namelabel];
		[namelabel release];
	}
	
	UIImageView* locationImageView = (UIImageView *) [msgCell viewWithTag:321];
	NSString* msgId = [data objectForKey:@"id"];
	NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgId, @"id", indexPath, @"indexPath", nil];
	NSString* lat = [data objectForKey:@"lat"];
	NSString* lng = [data objectForKey:@"lng"];
	NSString* url = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@,%@&size=110x110&zoom=%d&sensor=false&markers=color:blue|%@,%@", 
		lat, lng, 13, lat, lng];
	url = (NSString *)CFURLCreateStringByAddingPercentEscapes(
																				   NULL,
																				   (CFStringRef)url,
																				   NULL,
																				   (CFStringRef)@"|",
																				   kCFStringEncodingUTF8 );
	
	//NSString* url = [NSString stringWithFormat:@"http://st.map.qq.com/staticmap?zoom=13&center=%@,%@&size=110*110", lng, lat];
	//NSLog(@"the location url:%@", url);
	[locationImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:imageInfo];
	
	UILabel* label = (UILabel *) [msgCell viewWithTag:100];
    //NSLog(@"the description:%@", data);
	label.text = [data objectForKey:@"description"];
	
	UILabel* namelabel = (UILabel *) [msgCell viewWithTag:101];
	//namelabel.text = [NSString stringWithFormat:@"(%.3lf, %.3lf)", [lng doubleValue] , [lat doubleValue]];
	namelabel.text = @"";
	return msgCell;
	
}

-(void) listDidTouchAt:(NSIndexPath *) indexPath {
	if ([self.locationListDelegate respondsToSelector:@selector(locationList:didTouchAt:)]) {
		[self.locationListDelegate locationList:self didTouchAt:indexPath];
	}
}

@end
