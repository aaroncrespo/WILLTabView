//
//  WILLTabCell.h
//  WILLTabView
//
//  Created by Aaron C on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WILLSubTabCell : NSSegmentedCell

@property(assign, nonatomic) NSInteger mouseOverSegment;
@property(assign, nonatomic) NSInteger mouseDownSegment;

@end
