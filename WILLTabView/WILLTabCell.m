//
//  WILLTabCell.m
//  WILLTabView
//
//  Created by Aaron C on 12/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WILLTabCell.h"
#define TAB_HIGHLIGHT   "WILLTabCellSelectedBG"
#define TAB_SELECTED    "WILLTabCellSelectedBG"
#define TAB_NORMAL      "WILLTabViewBG"
#define TAB_BORDER      "WILLTabCellSelectedBorder"
#define TAB_WIDTH       25.0f
#define TAB_HEIGHT      24.0f
#define BAR_HEIGHT      28.0f

@implementation WILLTabCell

// TODO: monitor this for clickable area and button image alignment. 
- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    for (int i =0 ;i < [self segmentCount]; i++) {
            [self drawSegment:i inFrame:cellFrame withView:controlView];	
    }
}

- (void) drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView
{
    frame.origin.x = segment * TAB_WIDTH;
    frame.origin.y = (BAR_HEIGHT - TAB_HEIGHT) /2 ;
    frame.size.width = TAB_WIDTH;
    frame.size.height = TAB_HEIGHT;
    
    //there should be a way to remove the old control and transfer the event handling to the new one.
    [super setWidth:TAB_WIDTH forSegment:segment];

	NSImage *leftImage, *middleImage, *rightImage;
    
    if([self isSelectedForSegment:segment]) 
    {
        leftImage   = [NSImage imageNamed:@TAB_BORDER];
        middleImage = [NSImage imageNamed:@TAB_SELECTED];
        rightImage  = [NSImage imageNamed:@TAB_BORDER];
    }
    else if ([self isHighlighted]) {
        //may want a different image just for highlight
        leftImage   = [NSImage imageNamed:@TAB_SELECTED];
        middleImage = [NSImage imageNamed:@TAB_SELECTED];
        rightImage  = [NSImage imageNamed:@TAB_SELECTED];
    }
    else 
    {
        leftImage   = [NSImage imageNamed:@TAB_NORMAL];
        middleImage = [NSImage imageNamed:@TAB_NORMAL];
        rightImage  = [NSImage imageNamed:@TAB_NORMAL];

    }

    //    NSDrawThreePartImage(<#NSRect frame#>, <#NSImage *startCap#>, <#NSImage *centerFill#>, <#NSImage *endCap#>, <#BOOL vertical#>, <#NSCompositingOperation op#>, <#CGFloat alphaFraction#>, <#BOOL flipped#>)
    
    NSDrawThreePartImage(frame, leftImage, middleImage, rightImage,
						 NO, NSCompositeSourceOver, 1, YES);
   
    //need to add padding 
    //Im sure theres a better way of doing this.
    [[super imageForSegment:segment] setFlipped:YES];
    [[super imageForSegment:segment] drawInRect:NSMakeRect(frame.origin.x+7, frame.origin.y+4, frame.size.width -14, frame.size.height-8)
                                       fromRect:NSZeroRect 
                                      operation:NSCompositeSourceOver fraction:1];
}
@end