#import "WILLTabView.h"

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#define BAR_HEIGHT      28.0f
#define LEFT_PADDING    25.0f
#define BORDER_COLOR	[NSColor colorWithCalibratedWhite:(167/255.0f) alpha:1]
#define BAR_TEXTURE     "navBar"

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
[self selectTabViewItemAtIndex:1];	
}

-(void) dealloc {   
    self.segmentedControl = nil;
}
#pragma mark Callback - link our segementedControl to the tabViewItems

-(IBAction)ctrlSelected:(NSSegmentedControl *)sender {
    [super selectTabViewItemAtIndex:[sender selectedSegment]];
}

-(BOOL)isFlipped{return FALSE;}

// TODO: clip content under the bar.
-(void)drawRect:(NSRect)dirtyRect {

    NSRect bounds = [self bounds];
	
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
@end
