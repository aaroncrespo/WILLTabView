#import "WILLTabView.h"
#import "WILLTabCell.h"

#define BAR_HEIGHT      21.0f
#define LEFT_PADDING    20.0f

@implementation WILLTabView
@synthesize barView;
#pragma mark init

-(void)awakeFromNib {
    // Setup segmented control
    segmentedControl = [[NSSegmentedControl alloc] init];
    [segmentedControl setCell:[[WILLTabCell alloc] init]];    
    [segmentedControl setSegmentCount:tabView.numberOfTabViewItems];
    for (int i=0; i < tabView.numberOfTabViewItems; i++) {
        //[segmentedControl setLabel:[[self tabViewItemAtIndex:i] label] forSegment:i];
        [segmentedControl setImage:[NSImage imageNamed:[[tabView tabViewItemAtIndex:i] label]] forSegment:i];
    }    
    [segmentedControl setTarget:self];
    [segmentedControl setAction:@selector(ctrlSelected:)];
    [segmentedControl setSelectedSegment:[tabView indexOfTabViewItem:[tabView selectedTabViewItem]]];
    [self addSubview:segmentedControl];

    barView =  [[NSView alloc] init];    
    [barView setFrame:NSMakeRect(0,self.frame.size.height-BAR_HEIGHT,self.frame.size.width, BAR_HEIGHT)];
    [barView setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
    [self addSubview:barView];

 
    [segmentedControl setFrame:NSMakeRect(20, self.frame.size.height-BAR_HEIGHT, self.frame.size.width, BAR_HEIGHT)];
    [segmentedControl setAutoresizingMask:NSViewMinYMargin];


    [tabView setFrameSize:NSMakeSize(_bounds.size.width, _bounds.size.height - BAR_HEIGHT)];
    

}
-(void)drawRect:(NSRect)dirtyRect
{
    if (barView !=nil) {
        NSImage *barImage = [NSImage imageNamed:@"WILLTabViewBG"];
//        [barImage setFlipped:YES];
        [barImage drawInRect:(barView.frame)
                    fromRect:NSZeroRect 
                   operation:NSCompositeSourceOver fraction:1];

    }
}
#pragma mark Callback - link our segementedControl to the tabViewItems

-(void)ctrlSelected:(NSSegmentedControl *)sender {
    [tabView selectTabViewItemAtIndex:[sender selectedSegment]];
}

#pragma mark segment control and tabview sync methods

-(void)selectTabViewItem:(NSTabViewItem *)tabViewItem {
   [tabView selectTabViewItem:tabViewItem];
   [segmentedControl setSelectedSegment:[tabView indexOfTabViewItem:[tabView selectedTabViewItem]]];
}

-(void)selectTabViewItemAtIndex:(NSInteger)index {
   [tabView selectTabViewItemAtIndex:index];
   [segmentedControl setSelectedSegment:[tabView indexOfTabViewItem:[tabView selectedTabViewItem]]];
}

-(void)selectTabViewItemWithIdentifier:(id)identifier {
   [tabView selectTabViewItemWithIdentifier:identifier];
   [segmentedControl setSelectedSegment:[tabView indexOfTabViewItem:[tabView selectedTabViewItem]]];    
}
// skipping selectNext/PreviousTabViewItem - hoping they use above.

-(void)addTabViewItem:(NSTabViewItem *)anItem {
   [tabView addTabViewItem:anItem];
   [self awakeFromNib];
   [tabView setNeedsDisplay:YES];
}

-(void)removeTabViewItem:(NSTabViewItem *)anItem {
   [tabView removeTabViewItem:anItem];
   [self awakeFromNib];
   [tabView setNeedsDisplay:YES];
}
@end
