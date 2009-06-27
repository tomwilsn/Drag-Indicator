//
//  DragIndicatorPrefPanePref.m
//  DragIndicatorPrefPane
//
//  Created by Thomas Wilson on 23/06/09.
//  Copyright (c) 2009 Thomas Wilson. All rights reserved.
//

#import "DragIndicatorPrefPanePref.h"

#import "NDProcess.h"

@implementation DragIndicatorPrefPanePref

@synthesize isEnabledCheckbox;

- (id)initWithBundle:(NSBundle *)bundle
{
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        appID = CFSTR("com.tomwilson.DragIndicatorAgent");
    }
	
    return self;
}

- (void) dealloc
{
	CFRelease(appID);
	[isEnabledCheckbox release];
	[super dealloc];
}

- (void) mainViewDidLoad
{
	CFPropertyListRef value;
	
    /* Initialize the checkbox */
    value = CFPreferencesCopyAppValue( CFSTR("isEnabled"),  appID );
    if ( value && CFGetTypeID(value) == CFBooleanGetTypeID()  ) 
	{
        [isEnabledCheckbox setState:CFBooleanGetValue(value)];
		if (value)
		{
			[self startAgent];
			[self addLoginItem];
		}
		else
		{
			[self stopAgent];
			[self removeLoginItem];
		}
    }
	else 
	{
        [isEnabledCheckbox setState:YES];
		[self startAgent];
		[self addLoginItem];
    }
    if ( value ) CFRelease(value);
	
}

- (IBAction)isEnabledCheckboxClicked:(id)sender
{
	if ( [sender state] )
	{
        CFPreferencesSetAppValue( CFSTR("isEnabled"),
								 kCFBooleanTrue, appID );
		[self startAgent];
		[self addLoginItem];
	}
    else
	{
        CFPreferencesSetAppValue( CFSTR("isEnabled"),
								 kCFBooleanFalse, appID );
		
		[self stopAgent];
		[self removeLoginItem];
	}
}

- (void) startAgent
{
	if ([NDProcess everyProcessNamed:@"DragIndicatorAgent"].count > 0)
		return;
	
    NSString *bundlePath = [[[NSBundle bundleWithIdentifier:@"com.tomwilson.Drag_Indicator"] bundlePath]           // 1
				  stringByAppendingPathComponent:@"/Contents/Resources/DragIndicatorAgent.app"];
	NSURL *bundleURL = [NSURL fileURLWithPath:bundlePath];
	NSLog(bundlePath);
	
	[[NSWorkspace sharedWorkspace] openURLs:[NSArray arrayWithObject: bundleURL]
					withAppBundleIdentifier:@"" 
					options:NSWorkspaceLaunchAndHide | NSWorkspaceLaunchWithoutAddingToRecents
					additionalEventParamDescriptor:[NSAppleEventDescriptor nullDescriptor]
					launchIdentifiers:NULL];

}

- (OSStatus) stopAgent
{
	OSStatus err;
	AppleEvent event, reply;
	
	const char *bundleIDString = [@"com.tomwilson.DragIndicatorAgent" UTF8String];
	
	err = AEBuildAppleEvent(kCoreEventClass, kAEQuitApplication,
							typeApplicationBundleID,
							bundleIDString, strlen(bundleIDString),
							kAutoGenerateReturnID, kAnyTransactionID,
							&event, NULL, "");
	
	if (err) return err;
	err = AESendMessage(&event, &reply, kAENoReply, kAEDefaultTimeout);
	AEDisposeDesc(&event);
	return err;
}

- (void) addLoginItem
{
	NSMutableArray*        loginItems;
	
    loginItems = (NSMutableArray*) CFPreferencesCopyValue((CFStringRef)
														  @"AutoLaunchedApplicationDictionary", (CFStringRef) @"loginwindow",
														  kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    loginItems = [[loginItems autorelease] mutableCopy];
	 
	NSString *bundlePath = [[[NSBundle bundleWithIdentifier:@"com.tomwilson.Drag_Indicator"] bundlePath]           // 1
							stringByAppendingPathComponent:@"/Contents/Resources/DragIndicatorAgent.app"];
	
	BOOL exists = NO;
	for (int i = 0; i < [loginItems count]; ++i)
	{
		NSDictionary *dict = [loginItems objectAtIndex:i];
		NSString *path = [dict objectForKey:@"Path"];
		if ([path caseInsensitiveCompare:bundlePath] == 0)
		{
		    exists = YES;
			break;
		}
	}
	
	if (exists)
		return;
	
    //Do you stuff on "loginItems" array here
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[NSNumber numberWithBool:NO] forKey:@"Hidden"];
	[dict setObject:bundlePath forKey:@"Path"];
	
	[loginItems addObject:dict];
	[dict release];
	
    CFPreferencesSetValue((CFStringRef)
						  @"AutoLaunchedApplicationDictionary", loginItems, (CFStringRef)
						  @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFPreferencesSynchronize((CFStringRef) @"loginwindow",
							 kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	
    [loginItems release];
}

- (void) removeLoginItem
{
	NSMutableArray*        loginItems;
	
    loginItems = (NSMutableArray*) CFPreferencesCopyValue((CFStringRef)
														  @"AutoLaunchedApplicationDictionary", (CFStringRef) @"loginwindow",
														  kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    loginItems = [[loginItems autorelease] mutableCopy];
	
	NSString *bundlePath = [[[NSBundle bundleWithIdentifier:@"com.tomwilson.Drag_Indicator"] bundlePath]           // 1
							stringByAppendingPathComponent:@"/Contents/Resources/DragIndicatorAgent.app"];
	
	int index = -1;
	for (int i = 0; i < [loginItems count]; ++i)
	{
		NSDictionary *dict = [loginItems objectAtIndex:i];
		NSString *path = [dict objectForKey:@"Path"];
		if ([path caseInsensitiveCompare:bundlePath] == 0)
		{
		    index = i;
			break;
		}
	}
	
	if (index >= 0)
	{
		//Do you stuff on "loginItems" array here
		[loginItems removeObjectAtIndex:index];
		
		CFPreferencesSetValue((CFStringRef)
							  @"AutoLaunchedApplicationDictionary", loginItems, (CFStringRef)
							  @"loginwindow", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
		CFPreferencesSynchronize((CFStringRef) @"loginwindow",
								 kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	}
	
	
    [loginItems release];
}

@end
