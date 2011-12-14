#import "WILLTabView.h"
#import "WILLTabCell.h"

#define BAR_HEIGHT      21.0f
#define LEFT_PADDING    20.0f

@implementation WILLTabView

#pragma mark init

-(void)awakeFromNib {
    // Setup segmented control
    segmentedControl = [[WILLSegmentedControl alloc] init];
    [segmentedControl setTarget:self];
    [segmentedControl setAction:@selector(ctrlSelected:)];
    [segmentedControl setCell:[[WILLTabCell alloc] init]];    
    [segmentedControl setSegmentCount:self.numberOfTabViewItems];
    for (int i=0; i < self.numberOfTabViewItems; i++) {
        //[segmentedControl setLabel:[[self tabViewItemAtIndex:i] label] forSegment:i];
        [segmentedControl setImage:[NSImage imageNamed:[[self tabViewItemAtIndex:i] label]] forSegment:i];
    }    
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];
    [[self superview] addSubview:segmentedControl];
    [segmentedControl setFrame:NSMakeRect(0, self.frame.size.height-BAR_HEIGHT, self.frame.size.width, BAR_HEIGHT)];
    
    //content clipping.
    [self setFrameSize:NSMakeSize(_bounds.size.width, _bounds.size.height - BAR_HEIGHT)];
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
@end
