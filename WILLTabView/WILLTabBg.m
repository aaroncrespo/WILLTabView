//
//  WILLTabBg.m
//  WILLTabView
//
//  Created by Aaron C on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "WILLTabBg.h"

@implementation WILLTabBg

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)drawRect:(NSRect)dirtyRect
{
    NSImage *barImage = [NSImage imageNamed:@"WILLTabViewBG"];
    [barImage drawInRect:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height)
                fromRect:NSZeroRect 
               operation:NSCompositeSourceOver fraction:1];
    

}

@end
