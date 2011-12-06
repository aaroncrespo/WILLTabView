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
    
    NSArray * items = self.tabViewItems;
    NSUInteger n = [items count];

    [segmentedControl removeFromSuperview];
    [segmentedControl release];   

    NSRect frame;
    frame.size.width = TAB_WIDTH;
    frame.size.height = TAB_HEIGHT;
    frame.origin.x = self.bounds.origin.x + self.bounds.size.width / 2 - frame.size.width / 2;
    frame.origin.y = self.bounds.origin.y;
    

    
    segmentedControl = [[NSSegmentedControl alloc] initWithFrame:frame];                              
    [segmentedControl setSegmentStyle:NSSegmentStyleTexturedSquare];
    [segmentedControl setSegmentCount:n];
    
    for(NSUInteger i = 0; i < n; i++) {
        NSTabViewItem * item = (NSTabViewItem *)[items objectAtIndex:i];
        
        [segmentedControl setLabel:item.label forSegment:i];
        [segmentedControl setWidth:0 forSegment:i];
        [segmentedControl setTarget:self];
        [segmentedControl setAction:@selector(ctrlSelected:)];
    }
    [self addSubview:segmentedControl];


    NSSize s = ((NSSegmentedCell *)(segmentedControl.cell)).cellSize;
    maxWidth = s.width;
    


    
    [segmentedControl setSelectedSegment:[self indexOfTabViewItem:[self selectedTabViewItem]]];
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

    NSRect frame;
    frame.size.width = MIN(maxWidth,self.frame.size.width-TAB_HEIGHT);
    frame.size.height =  ((NSSegmentedCell *)(segmentedControl.cell)).cellSize.height;
    frame.origin.x = self.bounds.origin.x  + (self.bounds.size.width - frame.size.width) / 2;
    frame.origin.y = self.bounds.origin.y;
    
    [segmentedControl setFrame:frame];    
}

-(void)drawRect:(NSRect)dirtyRect {

    CGRect barFrame =  segmentedControl.frame;
    barFrame.origin.x += 2.0; 
    barFrame.origin.y += 2.0;
    barFrame.size.width -= 4.0;  
    barFrame.size.height -= 5.0;
        
    [super drawRect:dirtyRect];
}
-(void) dealloc {

    self.segmentedControl = nil;
    [super dealloc];
}
@end
