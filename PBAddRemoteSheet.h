//
//  PBAddRemoteSheet.h
//  GitX
//
//  Created by Nathan Kinsinger on 12/8/09.
//  Copyright 2009 Nathan Kinsinger. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class PBGitRepository;

@interface PBAddRemoteSheet : NSWindowController {
	PBGitRepository *repository;

	NSTextField *remoteName;
	NSTextField *remoteURL;
	NSTextField *errorMessage;

	NSOpenPanel *browseSheet;
	NSView      *browseAccessoryView;
    
    NSString *remoteUrl;
}

+ (void) beginAddRemoteSheetForRepository:(PBGitRepository *)repo withRemoteURL:(NSString*)url;

- (IBAction) browseFolders:(id)sender;
- (IBAction) addRemote:(id)sender;
- (IBAction) orderOutAddRemoteSheet:(id)sender;
- (IBAction) showHideHiddenFiles:(id)sender;


@property(strong) PBGitRepository *repository;

@property(strong) IBOutlet NSTextField *remoteName;
@property(strong) IBOutlet NSTextField *remoteURL;
@property(strong) IBOutlet NSTextField *errorMessage;

@property(strong)          NSOpenPanel *browseSheet;
@property(strong) IBOutlet NSView      *browseAccessoryView;

@end
