#import "WILLTabCell.h"

#define TAB_HIGHLIGHT   "WILLTabCellSelectedBG"
#define TAB_SELECTED    "WILLTabCellSelectedBG"
#define TAB_NORMAL      "WILLTabViewBG"
#define TAB_BORDER      "WILLTabCellSelectedBorder"

#define TAB_WIDTH       33.0f
#define TAB_HEIGHT      22.0f

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
    frame.origin.y = (controlView.frame.size.height - TAB_HEIGHT) /2 ;
    frame.size.width = TAB_WIDTH;
    frame.size.height = TAB_HEIGHT;
    
    [super setWidth:TAB_WIDTH forSegment:segment];

	NSImage *leftImage, *middleImage, *rightImage;

    //fall back incase my experiments fail, it wont crash
    leftImage   = [NSImage imageNamed:@TAB_NORMAL];
    middleImage = [NSImage imageNamed:@TAB_NORMAL];
    rightImage  = [NSImage imageNamed:@TAB_NORMAL];
       
    if (highlightedSegment == segment) {
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

    if (segment == highlightedSegment) {
        [[self image] drawInRect:NSMakeRect(frame.origin.x+9, frame.origin.y+3, frame.size.width -18, frame.size.height-6)
                        fromRect:NSZeroRect 
                       operation:NSCompositePlusDarker fraction:1];
        return ;
    }


    [[self image] drawInRect:NSMakeRect(frame.origin.x+9, frame.origin.y+3, frame.size.width -18, frame.size.height-6)
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

- (void)_updateHighlightedSegment:(NSPoint)currentPoint
                           inView:(NSView *)controlView {
     [self setHighlightedSegment:-1];
     NSPoint loc = currentPoint;
     NSRect frame = controlView.frame;
     loc.x += frame.origin.x;
     loc.y += frame.origin.y;
     NSUInteger i = 0, count = [self segmentCount];
     while(i < count && frame.origin.x < controlView.frame.size.width) {
         frame.size.width = [self widthForSegment:i];
         if(NSMouseInRect(loc, frame, NO))
         {
             [self setHighlightedSegment:i];
             break;
         }
         frame.origin.x += frame.size.width;
         i++;
     }
     
     [controlView setNeedsDisplay:YES];
}

- (BOOL)startTrackingAt:(NSPoint)startPoint 
                 inView:(NSView *)controlView {
    [self _updateHighlightedSegment:startPoint inView:controlView];
    return [super startTrackingAt:startPoint inView:controlView];
}

- (BOOL)continueTracking:(NSPoint)lastPoint 
                      at:(NSPoint)currentPoint 
                  inView:(NSView *)controlView {
    [self _updateHighlightedSegment:currentPoint inView:controlView];
    return [super continueTracking:lastPoint at:currentPoint inView:controlView];
}

- (void)stopTracking:(NSPoint)lastPoint 
                  at:(NSPoint)stopPoint 
              inView:(NSView *)controlView 
           mouseIsUp:(BOOL)flag; {
    
    if (highlightedSegment >= 0) {
        [self setSelectedSegment:highlightedSegment];
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:controlView];
        }
    }
    
    [self setHighlightedSegment:-1];
    [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
}

@end