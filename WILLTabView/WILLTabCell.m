#import "WILLTabCell.h"
#include "ThemeConstants.h"

@implementation WILLTabCell

@synthesize highlightedSegment;

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
    
    [super setWidth:TAB_WIDTH forSegment:segment];

	NSImage *leftImage, *middleImage, *rightImage;

    //fall back incase my experiments fail, it wont crash
    leftImage   = [NSImage imageNamed:@TAB_NORMAL];
    middleImage = [NSImage imageNamed:@TAB_NORMAL];
    rightImage  = [NSImage imageNamed:@TAB_NORMAL];
       
    if (highlightedSegment == segment) {
        NSLog(@"YES");
        leftImage   = [NSImage imageNamed:@TAB_BORDER];
        middleImage = [NSImage imageNamed:@TAB_SELECTED];
        rightImage  = [NSImage imageNamed:@TAB_BORDER];
    }
    else if([self isSelectedForSegment:segment] && highlightedSegment == -1) 
    {
        leftImage   = [NSImage imageNamed:@TAB_BORDER];
        middleImage = [NSImage imageNamed:@TAB_SELECTED];
        rightImage  = [NSImage imageNamed:@TAB_BORDER];
    }

    NSDrawThreePartImage(frame, leftImage, middleImage, rightImage,
						 NO, NSCompositeSourceOver, 1, YES);
   
    //need to add padding 
    //Im sure theres a better way of doing this.
    [self setImage:[super imageForSegment:segment]];
    [[super imageForSegment:segment] setFlipped:YES];
    [[self image] drawInRect:NSMakeRect(frame.origin.x+7, frame.origin.y+3, frame.size.width -14, frame.size.height-6)
                                       fromRect:NSZeroRect 
                                      operation:NSCompositeSourceOver fraction:1];
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if (![super initWithCoder:decoder])
        return nil;
    [self setHighlightedSegment:-1];
    return self;
}

- (BOOL)trackMouse:(NSEvent *)event inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp;
{
    [self setHighlightedSegment:-1];
    NSPoint loc = [event locationInWindow];
    NSRect frame = cellFrame;
    NSUInteger i = 0, count = [self segmentCount];
    loc = [controlView convertPoint:loc fromView:nil];
    while(i < count && frame.origin.x < cellFrame.size.width) {
        
        frame.size.width = [self widthForSegment:i];
        if(NSMouseInRect(loc, frame, NO))
        {
            [self setHighlightedSegment:i];
            break;
        }
        frame.origin.x+=frame.size.width;
        i++;
    }
    
    [controlView setNeedsDisplay:YES];
    return [super trackMouse:event inRect:cellFrame ofView:controlView untilMouseUp:untilMouseUp];
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag;
{
    [self setHighlightedSegment:-1];
    [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
}

@end