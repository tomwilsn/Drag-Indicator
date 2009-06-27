//
//  FramelessWindow.m
//  DragIndicator
//
//  Created by Thomas Wilson on 22/06/09.
//  Copyright 2009 Thomas Wilson. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "FramelessWindow.h"

#import "IndicatorView.h"


@implementation FramelessWindow

@synthesize initialLocation;
@synthesize indicatorView;

/*
 In Interface Builder, the class for the window is set to this subclass. Overriding the initializer provides a mechanism for controlling how objects of this class are created.
 */
- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag 
{
    // Using NSBorderlessWindowMask results in a window without a title bar.
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil) 
	{
        // Start with no transparency for all drawing into the window
        [self setAlphaValue:1.0];
        // Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
		
		[self setIgnoresMouseEvents:YES];
		
		[self setLevel:NSScreenSaverWindowLevel];

		
		NSSize size;
		size.width = 128;
		size.height = 128;

		[self setContentSize:size];
		
		[self setAlphaValue:0.0f];
	}
    return self;
}

- (void) awakeFromNib
{
	[self setIsVisible:NO];
}


/*
 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.
 */
- (BOOL)canBecomeKeyWindow 
{
    return NO;
}

- (BOOL)canBecomeMainWindow 
{
	return NO;
}


- (void) dealloc
{
	[IndicatorView release];
	[super dealloc];
}

@end

