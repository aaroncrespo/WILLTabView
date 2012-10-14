//
//  WILLTabCell.h
//  WILLTabView
//
//  Created by Aaron C on 12/8/11.
//  Copyright (c) 2011 WILL Interactive. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define WILLTabCell_TAB_WIDTH       33.0f

@interface WILLTabCell : NSSegmentedCell

@property(assign) NSInteger highlightedSegment;

@end