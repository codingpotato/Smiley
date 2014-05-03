//
//  CPConfig.m
//  Smiley
//
//  Created by wangyw on 3/29/14.
//  Copyright (c) 2014 codingpotato. All rights reserved.
//

#import "CPConfig.h"

@implementation CPConfig

+ (float)thumbnailSize {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        return 64.0;
    } else {
        return 128.0;
    }
}

@end
