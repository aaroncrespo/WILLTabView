#import "WILLTabCell.h"

#define TAB_HIGHLIGHT   "WILLTabCellSelectedBG"
#define TAB_SELECTED    "WILLTabCellSelectedBG"
#define TAB_NORMAL      "WILLTabViewBG"
#define TAB_BORDER      "WILLTabCellSelectedBorder"

#define TAB_WIDTH       33.0f
#define IMAGE_PADDING   3.0f
#define LEFT_PADDING    15.f

@implementation WILLTabCell

@synthesize highlightedSegment;
- (void) awakeFromNib
{

}
// TODO: monitor this for clickable area and button image alignment.
- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    for (int i =0 ;i < [self segmentCount]; i++) {
        [self drawSegment:i inFrame:cellFrame withView:controlView];
    }
}

- (void) drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView
{
    frame.origin.x = (segment * TAB_WIDTH);
    frame.origin.y = 0 ;
    frame.size.width = TAB_WIDTH;
    frame.size.height = controlView.frame.size.height;

    [super setWidth:TAB_WIDTH forSegment:segment];
	
    NSImage *leftImage, *middleImage, *rightImage;

    leftImage   = [NSImage imageNamed:@TAB_NORMAL];
    middleImage = [NSImage imageNamed:@TAB_NORMAL];
    rightImage  = [NSImage imageNamed:@TAB_NORMAL];
       
    if ((highlightedSegment == segment) | ([self isSelectedForSegment:segment] && highlightedSegment == -1)){
        leftImage   = [NSImage imageNamed:@TAB_BORDER];
        middleImage = [NSImage imageNamed:@TAB_SELECTED];
        rightImage  = [NSImage imageNamed:@TAB_BORDER];
    }

    NSUInteger operation = (segment == highlightedSegment) ? NSCompositePlusDarker : NSCompositeSourceOver;	

    NSDrawThreePartImage(frame, leftImage, middleImage, rightImage,
						 NO, NSCompositeSourceOver, 1, YES);
   
    [self setImage:[super imageForSegment:segment]];
    [[self imageForSegment:segment] setFlipped:YES];
    
    [[self image] drawInRect:[self imageRectForBounds:frame] fromRect:NSZeroRect 
                   operation:operation 
                    fraction:1];
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

// TODO: fix this warning.
- (void)stopTracking:(NSPoint)lastPoint 
                  at:(NSPoint)stopPoint 
              inView:(NSView *)controlView 
           mouseIsUp:(BOOL)flag; {

    [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
    if (highlightedSegment >= 0) {
        
        [self setSelectedSegment:highlightedSegment];
        if ([self.target respondsToSelector:self.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:controlView];
#pragma clang diagnostic pop
        }
    }
    
    [self setHighlightedSegment:-1];
}

@end