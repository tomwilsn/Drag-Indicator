//
//  MousePointerWindowController.m
//  DragIndicator
//
//  Created by Thomas Wilson on 22/06/09.
//  Copyright 2009 Thomas Wilson. All rights reserved.
//

#import "MousePointerWindowController.h"
#import "FramelessWindow.h"

CGEventRef eventTapCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
	MousePointerWindowController *controller = (MousePointerWindowController *) [[[[NSApplication sharedApplication] windows] objectAtIndex:0] windowController];
	
	if (type == kCGEventLeftMouseDragged)
	{
		[controller processDragEvent:CGEventGetLocation(event)];
	}
	else if (type == kCGEventLeftMouseUp)
	{
		[controller processMouseUpEvent];
	}
	
	return event;
}

@interface MousePointerWindowController(private)

- (void) processTimer:(id) sender;

@property (retain) NSTimer *fadeInOutTimer;
@property (retain) NSTimer *positionTimer;

@end

@implementation MousePointerWindowController

@synthesize newPosition;
@synthesize isDragging;

- (void) awakeFromNib
{		
	CFMachPortRef eventPort;
	CFRunLoopSourceRef  eventSrc;
	CFRunLoopRef    runLoop;
	
	eventPort = CGEventTapCreate(kCGSessionEventTap,
                                 kCGHeadInsertEventTap,
                                 kCGEventTapOptionListenOnly,
                                 CGEventMaskBit(kCGEventLeftMouseDragged) | CGEventMaskBit(kCGEventLeftMouseUp),
                                 eventTapCallback,
                                 NULL );
	if ( eventPort == NULL )
	{
		printf( "NULL event port\n" );
		exit( 1 );
	}
	
	eventSrc = CFMachPortCreateRunLoopSource(NULL, eventPort, 0);
	if ( eventSrc == NULL )
		printf( "No event run loop src?\n" );
	
	runLoop = CFRunLoopGetCurrent();
	if ( runLoop == NULL )
		printf( "No run loop?\n" );
	
	CFRunLoopAddSource(runLoop,  eventSrc, kCFRunLoopDefaultMode);
	
}

- (void) dealloc
{
	[positionTimer release];
	[fadeInOutTimer release];
	[super dealloc];
}

#pragma mark -
#pragma mark Mouse Handling

- (void) processDragEvent:(CGPoint) point
{

	self.newPosition = point;
	
	if (!isDragging)
	{
		self.isDragging = YES;
		[self.window setIsVisible:YES];
		self.fadeInOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(processTimer:) userInfo:NULL repeats:YES];
		self.positionTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0f target:self selector:@selector(updatePosition:) userInfo:NULL repeats:YES];
	}	
}

- (void) processMouseUpEvent
{
	if (isDragging)
	{
		self.isDragging = NO;
		//[self.window setIsVisible:NO];
		
		self.fadeInOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(processTimer:) userInfo:NULL repeats:YES];
		
		self.positionTimer = NULL;
	}
}

- (void) updatePosition:(id) sender
{
	// move the window
	NSPoint newOrigin;
	newOrigin.x = newPosition.x;
	newOrigin.y = newPosition.y;
	
	NSRect screenVisibleFrame = [[NSScreen mainScreen] frame];
	
	newOrigin.y = (screenVisibleFrame.size.height - newOrigin.y) - self.window.frame.size.height / 2;
	newOrigin.x = newOrigin.x - self.window.frame.size.width / 2;
	
	[self.window setFrameOrigin:newOrigin];
	
	
}



#pragma mark -
#pragma mark Private

- (void) processTimer:(id) sender
{
	if (isDragging)
	{
		if (self.window.alphaValue < 1)
			[self.window setAlphaValue:self.window.alphaValue+0.1];
		else
		{
			[fadeInOutTimer invalidate];
			[fadeInOutTimer release];
			fadeInOutTimer = NULL;
		}
	}
	else
	{
		if (self.window.alphaValue > 0)
			[self.window setAlphaValue:self.window.alphaValue-0.1];
		else
		{
			[fadeInOutTimer invalidate];
			[fadeInOutTimer release];
			fadeInOutTimer = NULL;
			[self.window setIsVisible:NO];
		}
		
	}
}


#pragma mark -
#pragma mark Properties

- (NSTimer *) fadeInOutTimer
{
	return fadeInOutTimer;
}
- (void)setFadeInOutTimer:(NSTimer *)timer
{
    [timer retain];
    [fadeInOutTimer invalidate];
    [fadeInOutTimer release];
    fadeInOutTimer=timer;
}


- (NSTimer *) positionTimer
{
	return positionTimer;
}
- (void)setPositionTimer:(NSTimer *)timer
{
    [timer retain];
    [positionTimer invalidate];
    [positionTimer release];
    positionTimer=timer;
}

@end
