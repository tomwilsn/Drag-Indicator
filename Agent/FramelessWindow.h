//
//  FramelessWindow.h
//  DragIndicator
//
//  Created by Thomas Wilson on 22/06/09.
//  Copyright 2009 Thomas Wilson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IndicatorView;

@interface FramelessWindow : NSWindow 
{
    // This point is used in dragging to mark the initial click location
    NSPoint initialLocation;
	
	IBOutlet IndicatorView *indicatorView;
}

@property (assign) NSPoint initialLocation;
@property (assign) IndicatorView *indicatorView;

@end
