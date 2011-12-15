//
//  TestView.m
//  WILLTabView
//
//  Created by Panupan Sriautharawong on 12/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TestView.h"

@implementation TestView
@synthesize bgColor;

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor valueForKey:self.bgColor ? self.bgColor : @"redColor"] setFill];
    NSRectFill(dirtyRect);
}

@end
