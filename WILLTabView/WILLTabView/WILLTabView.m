#import "WILLTabView.h"

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#define TAB_WIDTH       25.0f
#define TAB_HEIGHT      24.0f
#define BAR_HEIGHT      28.0f
#define LEFT_PADDING    25.0f
#define BORDER_COLOR	[NSColor colorWithCalibratedWhite:(167/255.0f) alpha:1]
#define BAR_TEXTURE     "navBar"
#define TAB_HIGHLIGHT   "LeftNavButtonPressed"
#define TAB_NORMAL      "LeftNavButton"
#define TAB_SELECTED    "LeftNavButtonPressed"

#pragma mark Segmentedcell Subclass
@implementation WILLTabCell
- (void) drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView
{

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

    //need to add padding 
	[buttonImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
    

    //Im sure theres a better way of doing this.
    [[super imageForSegment:segment]setFlipped:YES];
    [[super imageForSegment:segment] drawInRect:NSMakeRect(frame.origin.x+7, frame.origin.y+4, frame.size.width -14, frame.size.height-8)
                                       fromRect:NSZeroRect 
                                      operation:NSCompositeSourceOver fraction:1];
}
@end

#pragma mark TabView  Subclass
@implementation WILLTabView
@synthesize segmentedControl;

#pragma mark init

-(void)awakeFromNib {
    [segmentedControl setHidden:YES];
    [segmentedControl setSegmentCount:[self tabViewItems].count];
    [segmentedControl setTarget:self];
    [segmentedControl setAction:@selector(ctrlSelected:)];
    
    //sync external control to the internal
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];

}

-(void) dealloc {
    
    self.segmentedControl = nil;
    [super dealloc];
}
#pragma mark Callback - link our segementedControl to the tabViewItems

-(IBAction)ctrlSelected:(NSSegmentedControl *)sender {
    [super selectTabViewItemAtIndex:[sender selectedSegment]];
}

#pragma mark segment control and tabview sync methods

-(void)selectTabViewItem:(NSTabViewItem *)tabViewItem {
    [super selectTabViewItem:tabViewItem];
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];
}

-(void)selectTabViewItemAtIndex:(NSInteger)index {
    [super selectTabViewItemAtIndex:index];
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];
}

-(void)selectTabViewItemWithIdentifier:(id)identifier {
    [super selectTabViewItemWithIdentifier:identifier];
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];    
}
// skipping selectNext/PreviousTabViewItem - hoping they use above.

-(void)addTabViewItem:(NSTabViewItem *)anItem {
    [super addTabViewItem:anItem];
    [self awakeFromNib];
    [self setNeedsDisplay:YES];
}

-(void)removeTabViewItem:(NSTabViewItem *)anItem {
    [super removeTabViewItem:anItem];
    [self awakeFromNib];
    [self setNeedsDisplay:YES];
}

#pragma mark drawing
// TODO: clip content under the bar.
-(void)drawRect:(NSRect)dirtyRect {

    NSRect bounds = [[self superview] bounds];
	
    NSRect frame;
    frame.origin.x = 0;
    frame.origin.y = NSHeight(bounds) - BAR_HEIGHT;
    frame.size.width = NSWidth(bounds);
    frame.size.height =  BAR_HEIGHT;

	//Draw the bar image
	NSImage *barImage = [NSImage imageNamed:@BAR_TEXTURE];
    
	[barImage drawInRect:frame
                fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

    //Draw border, optional depending on the texture we end up using.
    
	NSRect borderRect = NSMakeRect(0, NSHeight(bounds)-BAR_HEIGHT,NSWidth(bounds), 1);
    [BORDER_COLOR set];
	[NSBezierPath fillRect:borderRect];

     
    [segmentedControl setFrame:NSMakeRect(LEFT_PADDING, frame.origin.y, frame.size.width, frame.size.height)];    
    [segmentedControl setHidden:FALSE];
    [super drawRect:dirtyRect];
}

-(BOOL)isFlipped
{
    return FALSE;
}
@end
