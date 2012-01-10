//
//  PBAddRemoteSheet.m
//  GitX
//
//  Created by Nathan Kinsinger on 12/8/09.
//  Copyright 2009 Nathan Kinsinger. All rights reserved.
//

#import "PBAddRemoteSheet.h"
#import "PBGitWindowController.h"
#import "PBGitRepository.h"



@interface PBAddRemoteSheet ()

- (void) beginAddRemoteSheetForRepository:(PBGitRepository *)repo withRemoteURL:(NSString*)url;
- (void) openAddRemoteSheet;

@end


@implementation PBAddRemoteSheet


@synthesize repository;

@synthesize remoteName;
@synthesize remoteURL;
@synthesize errorMessage;

@synthesize browseSheet;
@synthesize browseAccessoryView;

static PBAddRemoteSheet *sheet;

#pragma mark -
#pragma mark PBAddRemoteSheet

+ (void) beginAddRemoteSheetForRepository:(PBGitRepository *)repo withRemoteURL:(NSString*)url;
{
    if(!sheet){
        sheet = [[self alloc] initWithWindowNibName:@"PBAddRemoteSheet"];
    }
	[sheet beginAddRemoteSheetForRepository:repo withRemoteURL:url];
}


- (void) beginAddRemoteSheetForRepository:(PBGitRepository *)repo withRemoteURL:(NSString*)url
{
	self.repository = repo;
    remoteUrl = url;

	[self window];
	[self openAddRemoteSheet];
}


- (void) openAddRemoteSheet
{
	[self.errorMessage setStringValue:@""];
    
    if (remoteUrl)
    {
        [remoteURL setStringValue:remoteUrl];
        [remoteURL setEnabled:NO]; 
    }

	[NSApp beginSheet:[self window] modalForWindow:[self.repository.windowController window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
}


#pragma mark IBActions

- (IBAction) browseFolders:(id)sender
{
	[self orderOutAddRemoteSheet:nil];

    self.browseSheet = [NSOpenPanel openPanel];

	[browseSheet setTitle:@"Add remote"];
    [browseSheet setMessage:@"Select a folder with a git repository"];
    [browseSheet setCanChooseFiles:NO];
    [browseSheet setCanChooseDirectories:YES];
    [browseSheet setAllowsMultipleSelection:NO];
    [browseSheet setCanCreateDirectories:NO];
	[browseSheet setAccessoryView:browseAccessoryView];

    [browseSheet beginSheetModalForWindow:[self.repository.windowController window]
                         completionHandler:
     ^(NSInteger result) 
     {
         [browseSheet orderOut:self];
         
         if (result == NSFileHandlingPanelOKButton) 
         {
             [self.remoteURL setStringValue:[[browseSheet URL] path]];      
         }
         
        [self openAddRemoteSheet];
     }
     ];
}


- (IBAction) addRemote:(id)sender
{
	[self.errorMessage setStringValue:@""];

	NSString *name = [self.remoteName stringValue];

	if ([name isEqualToString:@""]) {
		[self.errorMessage setStringValue:@"Remote name is required"];
		return;
	}

	if (![self.repository checkRefFormat:[@"refs/remotes/" stringByAppendingString:name]]) {
		[self.errorMessage setStringValue:@"Invalid remote name"];
		return;
	}

	NSString *url = [self.remoteURL stringValue];
	if ([url isEqualToString:@""]) {
		[self.errorMessage setStringValue:@"Remote URL is required"];
		return;
	}

	[self orderOutAddRemoteSheet:self];
	[self.repository beginAddRemote:name forURL:url];
}


- (IBAction) orderOutAddRemoteSheet:(id)sender
{
	[NSApp endSheet:[self window]];
    [[self window] orderOut:self];
}


- (IBAction) showHideHiddenFiles:(id)sender
{
    [self.browseSheet setShowsHiddenFiles:[sender state]];
}


@end
