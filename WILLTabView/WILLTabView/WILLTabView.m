#import "WILLTabView.h"
#import "WILLTabCell.h"

@implementation WILLTabView

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        barImage = [NSImage imageNamed:@"WILLTabViewBG"];
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
        [segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];
        [segmentedControl setAutoresizingMask:NSViewMaxYMargin];
        [self addSubview:segmentedControl];
        
        [self setTabViewType:NSNoTabsNoBorder];    
        [self setDrawsBackground:NO];
        
        [segmentedControl setFrame:NSMakeRect(20, 0, self.frame.size.width, barImage.size.height)];
    }
    
    return self;
}

- (NSSize)minimumSize {
    return NSMakeSize(0, barImage.size.height);
}

- (NSRect)contentRect {
    return NSMakeRect(0, barImage.size.height, self.frame.size.width, self.frame.size.height-barImage.size.height);
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
    [barImage setFlipped:YES];
    [barImage drawInRect:NSMakeRect(0, 0, self.frame.size.width, barImage.size.height)
                fromRect:NSZeroRect 
               operation:NSCompositeSourceOver fraction:1];
}
@end
