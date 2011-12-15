#import "WILLTabView.h"
#import "WILLTabCell.h"

#define BAR_HEIGHT      21.0f
#define LEFT_PADDING    20.0f

@implementation WILLTabView
@synthesize barView;
#pragma mark init

-(void)awakeFromNib {
    //setup BG
    barView = [[WILLTabBg alloc] init];    
    [barView setFrame:NSMakeRect(0, self.frame.size.height-BAR_HEIGHT, self.frame.size.width, BAR_HEIGHT)];
    [barView setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
    [[super superview] addSubview:barView];

    // Setup segmented control
    segmentedControl = [[NSSegmentedControl alloc] init];
    [segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];
    [segmentedControl setCell:[[WILLTabCell alloc] init]];  
    [segmentedControl setSegmentCount:self.numberOfTabViewItems];   
    [segmentedControl setTarget:self];
    [segmentedControl setAction:@selector(ctrlSelected:)];

    for (int i=0; i < self.numberOfTabViewItems; i++) {
        [segmentedControl setImage:[NSImage imageNamed:[[self tabViewItemAtIndex:i] label]] forSegment:i];
    } 

    [segmentedControl setFrame:NSMakeRect(LEFT_PADDING, 0, self.frame.size.width, BAR_HEIGHT)];
    [segmentedControl setAutoresizingMask:NSViewMinYMargin];

    [barView addSubview:segmentedControl];

    //clipping
    [self setFrameSize:NSMakeSize([self bounds].size.width, [self bounds].size.height - BAR_HEIGHT)];
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];

}

#pragma mark Callback - link our segementedControl to the tabViewItems

-(void)ctrlSelected:(NSSegmentedControl *)sender {
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
@end
