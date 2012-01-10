//
//  PBChangeRemoteUrlSheet.h
//  GitX
//
//  Created by Robert Kyriakis on 27.12.2011.
//  Copyright 2011 Robert Kyriakis. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGitRefish.h"
#import "PBGitRepository.h"

@interface PBChangeRemoteUrlSheet : NSWindowController 
{
	IBOutlet NSTextField *RemoteNameTextField;
	IBOutlet NSTextField *RemoteUrlTextField;
	IBOutlet NSTextField *errorMessageTextField;
	IBOutlet NSView      *browseAccessoryView;
	NSOpenPanel *browseRemoteUrlPanel;
	NSString    *remoteUrl;
}

+ (void)showChangeRemoteUrlSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo;

- (IBAction) cancelOperation:(id)sender;
- (IBAction) changeOperation:(id)sender;
- (IBAction) browseRepository:(id)sender;
- (IBAction) showHideHiddenFiles:(id)sender;

@end
