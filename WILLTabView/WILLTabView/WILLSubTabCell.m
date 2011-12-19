#import "WILLSubTabCell.h"
#import "WILLSubTabView.h"
#define TAB_HIGHLIGHT   "WILLTabCellSelectedBG"
#define TAB_SELECTED    "WILLTabCellSelectedBG"
#define TAB_NORMAL      "WILLTabViewBG"
#define TAB_BORDER      "WILLTabCellSelectedBorder"

@implementation WILLSubTabCell

@synthesize mouseDownSegment;
@synthesize mouseOverSegment;
- (void) setSelectedSegment:(NSInteger)o {
    [super setSelectedSegment:o];
    mouseOverSegment = -1;
    mouseDownSegment = -1;
}
- (void) setMouseDownSegment:(NSInteger)o {
    mouseDownSegment = o;
    mouseOverSegment = -1;
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    for (int i =0 ;i < [self segmentCount]; i++) {
        [self drawSegment:i inFrame:cellFrame withView:controlView];
    }
}

- (void) drawSegment:(NSInteger)seg inFrame:(NSRect)frame withView:(NSView *)controlView
{
    NSString *label = [self labelForSegment:seg];
    NSSize textSize = [label sizeWithAttributes: [NSDictionary dictionary]];
    float totalWidth = 0;
    for (int i=0; i < seg; i++) {
        totalWidth += [self widthForSegment:i];
    }
    frame.origin.x = totalWidth;
    frame.origin.y = 0 ;
    frame.size.width = textSize.width+16;
    frame.size.height = controlView.frame.size.height;    
    
    [self setWidth:frame.size.width forSegment:seg];
    
    NSBezierPath* drawingPath = [NSBezierPath bezierPath];
    [drawingPath appendBezierPathWithRoundedRect:NSInsetRect(frame, 4, 3) xRadius:8 yRadius:8];
    [NSGraphicsContext saveGraphicsState];
    NSShadow* theShadow = [[NSShadow alloc] init];
    [theShadow setShadowOffset:NSMakeSize(0, 1)];
    [theShadow setShadowBlurRadius:0.0];
    
    if (seg == mouseDownSegment || [self isSelectedForSegment:seg]) {
        [theShadow setShadowColor:[[NSColor blackColor]                                   
                                   colorWithAlphaComponent:.5]];        
        [theShadow set];        
        [[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1] setFill];                
        [drawingPath fill]; 
    }
    else if (mouseOverSegment == seg) {
        [theShadow setShadowColor:[NSColor colorWithCalibratedRed:0.7 green:0.7 blue:0.7 alpha:1]];        
        [theShadow set];                
        [[NSColor colorWithCalibratedRed:0.6 green:0.6 blue:0.6 alpha:1] setFill];        
        [drawingPath fill];         
    }
    
    [NSGraphicsContext restoreGraphicsState];
    
    
    NSMutableParagraphStyle *paragraph;
    paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraph setAlignment:NSCenterTextAlignment];
    
    NSColor *textColor = mouseOverSegment == seg || seg == mouseDownSegment || [self isSelectedForSegment:seg] ? [NSColor whiteColor] : [NSColor blackColor];
    NSDictionary *labelAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSFont boldSystemFontOfSize:10], NSFontAttributeName, 
                               textColor, NSForegroundColorAttributeName, 
                               //shadow, NSShadowAttributeName, 
                               paragraph, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:label attributes:labelAttr];
    [attrStr drawInRect:NSInsetRect(frame, 2, 4)];
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if (![super initWithCoder:decoder])
        return nil;
    [self setMouseDownSegment:-1];
    [self setMouseOverSegment:-1];    
    return self;
}

- (void)_updateMouseDownSegment:(NSPoint)currentPoint
                         inView:(NSView *)controlView 
{
    NSPoint loc = currentPoint;
    NSRect frame = controlView.frame;
    loc.x += frame.origin.x;
    loc.y += frame.origin.y;
    NSUInteger i = 0, count = [self segmentCount];
    while(i < count && frame.origin.x < controlView.frame.size.width) {
        frame.size.width = [self widthForSegment:i];
        if(NSMouseInRect(loc, frame, NO))
        {
            [self setMouseDownSegment:i];
            [controlView setNeedsDisplay:YES];
            return;
        }
        frame.origin.x += frame.size.width;
        i++;
    }
    [self setMouseDownSegment:-1];    
    [controlView setNeedsDisplay:YES];    
}

- (BOOL)startTrackingAt:(NSPoint)startPoint 
                 inView:(NSView *)controlView {
    [self _updateMouseDownSegment:startPoint inView:controlView];
    return [super startTrackingAt:startPoint inView:controlView];
}

- (BOOL)continueTracking:(NSPoint)lastPoint 
                      at:(NSPoint)currentPoint 
                  inView:(NSView *)controlView {
    [self _updateMouseDownSegment:currentPoint inView:controlView];
    return [super continueTracking:lastPoint at:currentPoint inView:controlView];
}

// TODO: fix this warning.
- (void)stopTracking:(NSPoint)lastPoint 
                  at:(NSPoint)stopPoint 
              inView:(NSView *)controlView 
           mouseIsUp:(BOOL)flag; {
    
    [super stopTracking:lastPoint at:stopPoint inView:controlView mouseIsUp:flag];
    if (mouseDownSegment >= 0) {
        [self setSelectedSegment:mouseDownSegment];
        if ([self.target respondsToSelector:self.action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.action withObject:controlView];
#pragma clang diagnostic pop
        }
    }
    
    [controlView setNeedsDisplay:YES];
}

@end