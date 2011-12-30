//
//  PBChangeRemoteUrlSheet.m
//  GitX
//
//  Created by Robert Kyriakis on 27.12.2011.
//  Copyright 2011 Robert Kyriakis. All rights reserved.
//

#import "PBChangeRemoteUrlSheet.h"
#import "PBGitWindowController.h"
//#import "PBRepositoryDocumentController.h"
//#import "PBGitDefaults.h"

@interface PBChangeRemoteUrlSheet ()
- (void)showChangeRemoteUrlSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo;
@property (strong) PBGitRepository *repository;
@property (strong) id <PBGitRefish> startRefish;
@end



@implementation PBChangeRemoteUrlSheet

@synthesize repository;
@synthesize startRefish;

static PBChangeRemoteUrlSheet *sheet;


+ (void)showChangeRemoteUrlSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo;
{
	if (!sheet)
    {
        sheet = [[PBChangeRemoteUrlSheet alloc] initWithWindowNibName:@"PBChangeRemoteUrlSheet"];
    }
    [sheet showChangeRemoteUrlSheetAtRefish:ref inRepository:repo];
}


#pragma mark - IBAction methods

- (IBAction)cancelOperation:(id)sender
{
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
}


- (IBAction)changeOperation:(id)sender
{
    [self cancelOperation:sender];

    NSString *currentPath = [RemoteUrlTextField stringValue];
    NSURL *newUrl = [NSURL URLWithString:[currentPath stringByAddingPercentEscapesUsingEncoding:NSStringEncodingConversionExternalRepresentation]];
    NSString *remoteName = [self.startRefish shortName];
    
    [self.repository changeRemote:remoteName toURL:newUrl];
}


- (IBAction)browseRepository:(id)sender
{
    [browseRemoteUrlPanel beginSheetModalForWindow:[self window]
                        completionHandler:
     ^(NSInteger result) 
     {
         [browseRemoteUrlPanel orderOut:self];
         
         if (result == NSFileHandlingPanelOKButton) 
         {
             [RemoteUrlTextField setStringValue:[[browseRemoteUrlPanel URL]  path]];
         }
     }
     ];
}


#pragma mark - Extension methods
- (void)showChangeRemoteUrlSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo
{
	self.repository = repo;
	self.startRefish = ref;
    
	[self window];
    
    [errorMessageTextField setHidden:YES];
    
    [RemoteNameTextField setStringValue:[NSString stringWithFormat:@"Change URL from Remote %@",[self.startRefish shortName]]];
    [RemoteUrlTextField setStringValue:@""];
    
    NSString *remoteURL = [repo remoteUrl:[self.startRefish shortName]];
    
    if (remoteURL)
    {
        [RemoteUrlTextField setStringValue:remoteURL];
    }
    else
    {
        [errorMessageTextField setStringValue:@"Get current URL from remote failed!"];
        [errorMessageTextField setHidden:NO];
    }
    
	browseRemoteUrlPanel = [NSOpenPanel openPanel];
	[browseRemoteUrlPanel setTitle:@"Browse to change the git remote repository Url"];
	[browseRemoteUrlPanel setMessage:@"Select a new folder with a git repository"];
	[browseRemoteUrlPanel setPrompt:@"Select"];
    [browseRemoteUrlPanel setCanChooseFiles:NO];
    [browseRemoteUrlPanel setCanChooseDirectories:YES];
    [browseRemoteUrlPanel setAllowsMultipleSelection:NO];
	[browseRemoteUrlPanel setCanCreateDirectories:NO];
    
	[NSApp beginSheet:[self window] 
       modalForWindow:[self.repository.windowController window] 
        modalDelegate:self 
       didEndSelector:Nil 
          contextInfo:Nil];
}

@end