//
//  IndicatorView.m
//  DragIndicator
//
//  Created by Thomas Wilson on 22/06/09.


//  Copyright 2009 Thomas Wilson. All rights reserved.
//

#import "IndicatorView.h"


@implementation IndicatorView

@synthesize indicatorImage;

/*
 This routine is called at app launch time when this class is unpacked from the nib.
 */
- (void)awakeFromNib {
    // Load the images from the bundle's Resources directory
    self.indicatorImage = [NSImage imageNamed:@"circle"];

	[[self window] setHasShadow:NO];
	
	NSSize size;
	size.width = indicatorImage.size.width;
	size.height = indicatorImage.size.height;
	
	[self setFrameSize:size];
}

- (void)dealloc {
    [indicatorImage release];
    [super dealloc];
}

/*
 When it's time to draw, this routine is called. This view is inside the window, the window's opaqueness has been turned off, and the window's styleMask has been set to NSBorderlessWindowMask on creation, so this view draws the all the visible content. The first two lines below fill the view with "clear" color, so that any images drawn also define the custom shape of the window.  Furthermore, if the window's alphaValue is less than 1.0, drawing will use transparency.
 */
- (void)drawRect:(NSRect)rect {
    // Clear the drawing rect.
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
    // A boolean tracks the previous shape of the window. If the shape changes, it's necessary for the

	[indicatorImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
}

@end