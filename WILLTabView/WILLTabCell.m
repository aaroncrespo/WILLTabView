//
//  WILLTabCell.m
//  WILLTabView
//
//  Created by Aaron C on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WILLTabCell.h"
#define TAB_HIGHLIGHT   "LeftNavButtonPressed"
#define TAB_NORMAL      "LeftNavButton"
#define TAB_SELECTED    "LeftNavButtonPressed"
#define TAB_WIDTH       25.0f
#define TAB_HEIGHT      24.0f
#define BAR_HEIGHT      28.0f

@implementation WILLTabCell

- (void) drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView
{
    [super drawSegment:segment inFrame:NSZeroRect withView:controlView];
    frame.origin.x = segment * TAB_WIDTH;
    frame.origin.y = (BAR_HEIGHT - TAB_HEIGHT) /2 ;
    frame.size.width = TAB_WIDTH;
    frame.size.height = TAB_HEIGHT;
    
    //there should be a way to remove the old control and transfer the event handling to the new one.
    [super setWidth:TAB_WIDTH -4 forSegment:segment];
    
    NSImage *buttonImage;
    if([self isSelectedForSegment:segment]) 
    {
        buttonImage = [NSImage imageNamed:@TAB_SELECTED];
    }
    else if ([self isHighlighted]) {
        //may want a diferent image just for highlight
        buttonImage = [NSImage imageNamed:@TAB_HIGHLIGHT];
    }
    else 
    {
        buttonImage = [NSImage imageNamed:@TAB_NORMAL];
    }
    //Can substitute with NSDrawThreePartImage if needed.
    
	[buttonImage setFlipped:[[self controlView] isFlipped]];
    
	[buttonImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    
    //need to add padding 
    //Im sure theres a better way of doing this.
    [[super imageForSegment:segment]setFlipped:YES];
    [[super imageForSegment:segment] drawInRect:NSMakeRect(frame.origin.x+7, frame.origin.y+4, frame.size.width -14, frame.size.height-8)
                                       fromRect:NSZeroRect 
                                      operation:NSCompositeSourceOver fraction:1];
}
@end