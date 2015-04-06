//
//  Arrow.h
//  HW5
//
//  Created by MEI C on 3/13/14.
//  Copyright (c) 2014 MEI C. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Arrow : NSObject
@property (nonatomic, strong) UIImageView *view;
@property (nonatomic, strong) NSString *direction;
-(instancetype) initWithView:(UIImageView *) imageview andDirection:(NSString *) dString;
@end
