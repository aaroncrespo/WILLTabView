#import "WILLTabView.h"

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#define TAB_WIDTH       25.0f
#define TAB_HEIGHT      25.0f
#define BAR_HEIGHT      30.0f
#define LEFT_PADDING    25.0f
#define BORDER_COLOR				[NSColor colorWithCalibratedWhite:(167/255.0f) alpha:1]

@implementation WILLTabView
@synthesize segmentedControl;

-(void)rework {
    
    [segmentedControl setHidden:YES];
    [segmentedControl setSegmentStyle:NSSegmentStyleSmallSquare];
    [segmentedControl setSegmentCount:[self tabViewItems].count];
    
    for(NSTabViewItem *tab in self.tabViewItems) {
        [segmentedControl setTarget:self];
        [segmentedControl setAction:@selector(ctrlSelected:)];
    }
}

#pragma standard init and friends.

-(id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    if (self == nil)
        return nil;

    [self rework];
    return self;
}

-(void)awakeFromNib {
    [self rework];
}

#pragma mark Callback - to link our sgementedControl to the tabViewItems

-(IBAction)ctrlSelected:(NSSegmentedControl *)sender {
    [super selectTabViewItemAtIndex:[sender selectedSegment]];
}

#pragma mark Keep tabs on what gets selected - so our own segmentedControl stays synced.

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

#pragma drawing and alignments

-(void)drawRect:(NSRect)dirtyRect {

    NSRect bounds = [[self superview] bounds];
	
    NSRect frame;
    frame.size.width = NSWidth(bounds);
    frame.size.height =  TAB_HEIGHT;
    frame.origin.x = self.bounds.origin.x + LEFT_PADDING;
    frame.origin.y = NSHeight(bounds) - BAR_HEIGHT;
        
	//Draw the bar image
	NSImage *barImage = [NSImage imageNamed:@"navBar"];
    
	[barImage drawInRect:frame fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	NSLog(@"%@",NSStringFromRect( frame));
    
    [segmentedControl setFrame:frame];    
    [segmentedControl setHidden:FALSE];
    [super drawRect:dirtyRect];
}
-(void) dealloc {

    self.segmentedControl = nil;
    [super dealloc];
}
-(BOOL)isFlipped
{
    return FALSE;
}
@end
