//
//  IndicatorView.h
//  DragIndicator
//
//  Created by Thomas Wilson on 22/06/09.
//  Copyright 2009 Thomas Wilson. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IndicatorView : NSView 
{
	NSImage *indicatorImage;
}

@property (retain) NSImage *indicatorImage;

@end

