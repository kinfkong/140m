//
//  KKUserListView.m
//  obanana
//
//  Created by Wang Jinggang on 11-7-13.
//  Copyright 2011 tencent. All rights reserved.
//

#import "KKUserListView.h"
#import "UserModel.h"
#import "UtilModel.h"



@implementation KKUserListView

@synthesize userListdelegate;



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
		//self.url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/follow/index/user/%@/", [[UserModel getInstance] getUserName]];
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
	[userListdelegate release];
	//[url release];
    [super dealloc];
}


-(CGFloat) cellHeight:(NSDictionary *) data tableView:(UITableView *) _tableView {
	return 60;
}

-(UITableViewCell *) tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath data:(NSDictionary *) data {
	static NSString* identifier = @"KKUserListView";
	UITableViewCell* msgCell = (UITableViewCell *) [_tableView dequeueReusableCellWithIdentifier:identifier];
	if (msgCell == nil) {
		msgCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
		UIImageView* authorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 50, 50)];
		authorImageView.tag = 321;
		[msgCell addSubview:authorImageView];
		[authorImageView release];
		
		authorImageView.layer.masksToBounds = YES;
		authorImageView.layer.cornerRadius = 4.0;
		authorImageView.layer.borderWidth = 0.0;
		authorImageView.layer.borderColor = [[UIColor clearColor] CGColor];
		authorImageView.userInteractionEnabled = YES;
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(65, 3, 320 - 65, 25)];
		label.font = [UIFont boldSystemFontOfSize:20.0f];
		label.tag = 100;
		[msgCell addSubview:label];
		[label release];
		
		UILabel* namelabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 28, 320 - 65, 20)];
		namelabel.font = [UIFont systemFontOfSize:18.0f];
		namelabel.tag = 101;
		namelabel.textColor = [UIColor grayColor];
		[msgCell addSubview:namelabel];
		[namelabel release];
		
		UILabel* descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(310 - 100, 5, 100, 16)];
		descriptionLabel.font = [UIFont systemFontOfSize:12.0f];
		descriptionLabel.textAlignment = UITextAlignmentRight;
		descriptionLabel.tag = 201;
		descriptionLabel.textColor = [UIColor grayColor];
		[msgCell addSubview:descriptionLabel];
		[descriptionLabel release];
	}
	
	UIImageView* authorImageView = (UIImageView *) [msgCell viewWithTag:321];
	NSString* msgId = [data objectForKey:@"id"];
	NSMutableDictionary* imageInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:msgId, @"id", indexPath, @"indexPath", nil];
	NSString* url = [NSString stringWithFormat:@"http://m.obanana.com/index.php/img/head/%@/180", [data objectForKey:@"head_image_id"]];
	[authorImageView loadImageWithURL:url tmpImage:[UIImage imageNamed:@"noimage.png"] cache:YES delegate:nil withObject:imageInfo];
	
	UILabel* label = (UILabel *) [msgCell viewWithTag:100];
	label.text = [data objectForKey:@"user_nick"];
	
	UILabel* namelabel = (UILabel *) [msgCell viewWithTag:101];
	namelabel.text = [NSString stringWithFormat:@"@%@", [data objectForKey:@"user_name"]];
	
	NSString* description = [data objectForKey:@"description"];
	UILabel* descriptionLabel = (UILabel *) [msgCell viewWithTag:201];
	if (description != nil) {
		// TODO:
		if ([self.userListdelegate respondsToSelector:@selector(userList:modifyDescriptionLabelText:)]) {
			descriptionLabel.text = [self.userListdelegate userList:self modifyDescriptionLabelText:description];
		} else {
			descriptionLabel.text = description;
		}
	} else {
		descriptionLabel.text = @"";
	}
	return msgCell;
	
}

-(void) listDidTouchAt:(NSIndexPath *) indexPath {
	if ([self.userListdelegate respondsToSelector:@selector(userList:didTouchAt:)]) {
		[self.userListdelegate userList:self didTouchAt:indexPath];
	}
}

@end

