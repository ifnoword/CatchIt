//
//  Arrow.m
//  HW5
//
//  Created by MEI C on 3/13/14.
//  Copyright (c) 2014 MEI C. All rights reserved.
//

#import "Arrow.h"

@implementation Arrow
-(instancetype) initWithView:(UIImageView *) imageview andDirection:(NSString *) dString{
    self =[super init];
    self.direction = dString;
    self.view = imageview;
    return self;
}
@end
