//
//  MousePointerWindowController.h
//  DragIndicator
//
//  Created by Thomas Wilson on 22/06/09.
//  Copyright 2009 Thomas Wilson. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MousePointerWindowController : NSWindowController {
	BOOL isDragging;
	
	NSTimer *fadeInOutTimer;
	NSTimer *positionTimer;
	
	CGPoint newPosition;
}

- (void) processDragEvent:(CGPoint) point;
- (void) processMouseUpEvent;

- (void) updatePosition:(id) sender;

@property (assign) BOOL isDragging;
@property (assign) CGPoint newPosition;

@end
