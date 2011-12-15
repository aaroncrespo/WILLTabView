//
//  WILLTabView.h
//  WILLTabView
//
//  Created by Aaron C on 12/6/11.
//  Copyright (c) 2011 WILLINTERACTIVE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface WILLTabView : NSView {
    IBOutlet NSTabView *tabView;
    NSSegmentedControl *segmentedControl;    
}
@property (strong) NSView *barView;
@end