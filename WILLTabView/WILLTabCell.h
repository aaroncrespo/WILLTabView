//
//  WILLTabCell.h
//  WILLTabView
//
//  Created by Aaron C on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface WILLTabCell : NSSegmentedCell {
    NSInteger highlightedSegment;
}
@property(assign) NSInteger highlightedSegment;

@end
