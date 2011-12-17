#import "WILLSubTabCell.h"

#define TAB_HIGHLIGHT   "WILLTabCellSelectedBG"
#define TAB_SELECTED    "WILLTabCellSelectedBG"
#define TAB_NORMAL      "WILLTabViewBG"
#define TAB_BORDER      "WILLTabCellSelectedBorder"

@implementation WILLSubTabCell

@synthesize highlightedSegment;
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
    frame.size.width = textSize.width+20;
    frame.size.height = controlView.frame.size.height;    
    
    [self setWidth:frame.size.width forSegment:seg];
    
    NSBezierPath* drawingPath = [NSBezierPath bezierPath];
    [drawingPath appendBezierPathWithRoundedRect:NSInsetRect(frame, 2, 2) xRadius:10 yRadius:10];
    [[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:.4] setFill];
    if (seg == highlightedSegment || [self isSelectedForSegment:seg]) {
        [drawingPath fill]; 
        [drawingPath setLineWidth:1];  
        [[NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:.1] set];
        [drawingPath stroke];        
    }

    NSMutableParagraphStyle *paragraph;
    paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByTruncatingTail];
    [paragraph setAlignment:NSCenterTextAlignment];
    
    NSDictionary *labelAttr = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         [NSFont systemFontOfSize:[NSFont smallSystemFontSize]], NSFontAttributeName, 
                               [self isSelectedForSegment:seg] ? [NSColor whiteColor] : [NSColor blackColor], NSForegroundColorAttributeName, 
                                                         //shadow, NSShadowAttributeName, 
                                                         paragraph, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:label attributes:labelAttr];
    [attrStr drawInRect:NSInsetRect(frame, 2, 3)];
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