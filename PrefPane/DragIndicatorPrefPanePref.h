//
//  DragIndicatorPrefPanePref.h
//  DragIndicatorPrefPane
//
//  Created by Thomas Wilson on 23/06/09.
//  Copyright (c) 2009 Thomas Wilson. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@interface DragIndicatorPrefPanePref : NSPreferencePane 
{
	CFStringRef appID;
	
	IBOutlet NSButton    *isEnabledCheckbox;
}

@property (retain) NSButton *isEnabledCheckbox;

- (void) mainViewDidLoad;
- (IBAction)isEnabledCheckboxClicked:(id)sender;

- (void) startAgent;
- (OSStatus) stopAgent;
- (void) addLoginItem;
- (void) removeLoginItem;

@end
