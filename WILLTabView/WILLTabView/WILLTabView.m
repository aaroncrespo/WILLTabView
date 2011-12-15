#import "WILLTabView.h"
#import "WILLTabCell.h"

#define BAR_HEIGHT      21.0f
#define LEFT_PADDING    20.0f

@implementation WILLTabView

#pragma mark init
-(void)awakeFromNib {
    // Setup segmented control
    segmentedControl = [[NSSegmentedControl alloc] init];
    [segmentedControl setCell:[[WILLTabCell alloc] init]];    
    [segmentedControl setSegmentCount:self.numberOfTabViewItems];   
    [segmentedControl setTarget:self];
    [segmentedControl setAction:@selector(ctrlSelected:)];
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];
    for (int i=0; i < self.numberOfTabViewItems; i++) {
        [segmentedControl setImage:[NSImage imageNamed:[[self tabViewItemAtIndex:i] label]] forSegment:i];
    } 
    [segmentedControl setFrame:NSMakeRect(LEFT_PADDING, 0, self.frame.size.width, BAR_HEIGHT)];
    [segmentedControl setAutoresizingMask:NSViewMinYMargin];
    [self addSubview:segmentedControl];
    
	[self setTabViewType:NSNoTabsNoBorder];    
	[self setDrawsBackground:NO];
}

- (NSSize)minimumSize {
    return NSMakeSize(0, BAR_HEIGHT);
}

- (NSRect)contentRect {
    return NSMakeRect(0, BAR_HEIGHT, self.frame.size.width, self.frame.size.height-BAR_HEIGHT);
}

#pragma mark Callback - link our segementedControl to the tabViewItems

-(void)ctrlSelected:(NSSegmentedControl *)sender {
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

- (void)drawRect:(NSRect)dirtyRect {
    NSImage *barImage = [NSImage imageNamed:@"WILLTabViewBG"];
    [barImage drawInRect:NSMakeRect(0, 0, self.frame.size.width, BAR_HEIGHT)
                fromRect:NSZeroRect 
               operation:NSCompositeSourceOver fraction:1];
}
@end
