//
//  WILLTabView.h
//  WILLTabView
//
//  Created by Aaron C on 12/6/11.
//  Copyright (c) 2011 WILLINTERACTIVE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//TODO: breakout the segmented control into a IB outlet to allow images properties to be set with IB
@interface WILLTabView : NSTabView {
@private
    double maxWidth;
}

@property (strong) IBOutlet NSSegmentedControl *segmentedControl;
@end
