//
//  AppDelegate.h
//  WILLTabView
//
//  Created by Aaron C on 12/6/11.
//  Copyright (c) 2011 WILLINTERACTIVE. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WILLTabView.h"
@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    WILLTabView *tabView;
}
@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet WILLTabView *tabView;
@end
