#import "WILLTabView.h"

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#define TAB_WIDTH       25.0f
#define TAB_HEIGHT      25.0f
#define BAR_HEIGHT      25.0f
#define LEFT_PADDING    25.0f
#define BORDER_COLOR				[NSColor colorWithCalibratedWhite:(167/255.0f) alpha:1]

@implementation WILLTabCell
- (void)drawWithExpansionFrame:(NSRect)cellFrame inView:(NSView *)view
{
    
}
//- (NSBackgroundStyle) backgroundStyle {
//    
//}
- (void)drawSegment:(NSInteger)segment inFrame:(NSRect)frame withView:(NSView *)controlView
{
    //+-5 just for some extra width so I can see everything thats drawing.
    //frame = NSMakeRect(TAB_WIDTH * segment +5 , 0, TAB_WIDTH -5, TAB_HEIGHT);
    
    //if you click in an area not above the underneith controller it wont respond.
    frame = NSMakeRect(TAB_WIDTH * segment , 0, TAB_WIDTH, TAB_HEIGHT);    

	NSImage *buttonImage;
    if( ([super selectedSegment] == segment)) 
        buttonImage = [NSImage imageNamed:@"LeftNavButtonPressed"];
    else 
        buttonImage = [NSImage imageNamed:@"LeftNavButton"];

	[buttonImage setFlipped:[[self controlView] isFlipped]];
	[buttonImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

    //Can substitute with NSDrawThreePartImage if needed.

}

@end

@class WILLTabCell;
@implementation WILLTabView
@synthesize segmentedControl;

#pragma mark init

-(void)awakeFromNib {
    [segmentedControl setHidden:YES];
    [segmentedControl setSegmentStyle:NSSegmentStyleSmallSquare];    
    [segmentedControl setCell:[[WILLTabCell alloc] init]];
    

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
	NSImage *barImage = [NSImage imageNamed:@"navBar"];
    
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
