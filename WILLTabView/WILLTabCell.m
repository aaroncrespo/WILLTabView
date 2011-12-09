#import "WILLTabCell.h"
#include "ThemeConstants.h"

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
    
    [super setWidth:TAB_WIDTH forSegment:segment];

	NSImage *leftImage, *middleImage, *rightImage;

    NSLog(@"action %ld",[self mouseDownFlags]);
       
    if([self isSelectedForSegment:segment] && ![self isHighlighted]) 
    {
        leftImage   = [NSImage imageNamed:@TAB_BORDER];
        middleImage = [NSImage imageNamed:@TAB_SELECTED];
        rightImage  = [NSImage imageNamed:@TAB_BORDER];
    }
    else 
    {
        leftImage   = [NSImage imageNamed:@TAB_NORMAL];
        middleImage = [NSImage imageNamed:@TAB_NORMAL];
        rightImage  = [NSImage imageNamed:@TAB_NORMAL];
        
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
- (BOOL)prefersTrackingUntilMouseUp
{
    return false;
}
-(NSInteger)selectedSegment 
{
    NSLog(@"selection %ld",[super selectedSegment]);
    return [super selectedSegment];
}

-(NSInteger)mouseDownFlags
{
    NSLog(@"action %ld",[super mouseDownFlags]);
    return [super mouseDownFlags];
}
@end