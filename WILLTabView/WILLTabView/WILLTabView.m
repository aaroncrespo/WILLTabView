#import "WILLTabView.h"

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

#define TAB_WIDTH       25.0f
#define TAB_HEIGHT      25.0f
#define BAR_HEIGHT      30.0f
#define LEFT_PADDING    25.0f

@implementation WILLTabView
@synthesize segmentedControl;
//TODO: explore removing this with IB object.
-(void)rework {
    
    // might be a good place to draw the skin
    [self viewWillDraw];

    [segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];
    [segmentedControl setSegmentCount:[self tabViewItems].count];
    
    for(NSTabViewItem *tab in self.tabViewItems) {
        [segmentedControl setTarget:self];
        [segmentedControl setAction:@selector(ctrlSelected:)];
    }

//    NSSize s = ((NSSegmentedCell *)(segmentedControl.cell)).cellSize;
//    maxWidth = s.width;
//    
//    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];
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

-(void)viewWillDraw {
//
//    NSRect frame;
//    frame.size.width = MIN(maxWidth,self.frame.size.width-TAB_HEIGHT);
//    frame.size.height =  ((NSSegmentedCell *)(segmentedControl.cell)).cellSize.height;
//    frame.origin.x = self.bounds.origin.x  + (self.bounds.size.width - frame.size.width) / 2;
//    frame.origin.y = self.bounds.origin.y;
//    
//    [segmentedControl setFrame:frame];    
}

-(void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
-(void) dealloc {

    self.segmentedControl = nil;
    [super dealloc];
}
@end
