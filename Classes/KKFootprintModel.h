//
//  KKFootprintModel.h
//  obanana
//
//  Created by Wang Jinggang on 11-7-19.
//  Copyright 2011 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface KKFootprintModel : UIViewController {

}

+(KKFootprintModel *) getInstance;

-(void) sendFootprint:(CLLocation*) location;

@end
