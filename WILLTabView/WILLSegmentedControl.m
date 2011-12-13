//
//  WILLSegmentedControl.m
//  WILLTabView
//
//  Created by Aaron C on 12/13/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WILLSegmentedControl.h"
#import "WILLTabCell.h"

@implementation WILLSegmentedControl
-(void)drawRect:(NSRect)dirtyRect
{    

    NSImage *barImage = [NSImage imageNamed:@"WILLTabViewBG"];
    [barImage setFlipped:TRUE];
	[barImage drawInRect:NSMakeRect(0, 0, NSWidth(dirtyRect), NSHeight(dirtyRect))
                fromRect:NSZeroRect 
               operation:NSCompositeSourceAtop fraction:1];
    [super drawRect:dirtyRect];
}
@end
