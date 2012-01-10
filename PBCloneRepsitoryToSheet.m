//
//  PBCloneRepsitoryToSheet.m
//  GitX
//
//  Created by Nathan Kinsinger on 2/7/10.
//  Copyright 2010 Nathan Kinsinger. All rights reserved.
//

#import "PBCloneRepsitoryToSheet.h"
#import "PBGitRepository.h"
#import "PBGitWindowController.h"


@interface PBCloneRepsitoryToSheet ()

- (void) beginCloneRepsitoryToSheetForRepository:(PBGitRepository *)repo;

@end


@implementation PBCloneRepsitoryToSheet

@synthesize repository;
@synthesize isBare;
@synthesize message;
@synthesize cloneToAccessoryView;

static PBCloneRepsitoryToSheet *sheet;

#pragma mark -
#pragma mark PBCloneRepsitoryToSheet

+ (void) beginCloneRepsitoryToSheetForRepository:(PBGitRepository *)repo
{
    if (!sheet) {
        sheet = [[self alloc] initWithWindowNibName:@"PBCloneRepsitoryToSheet"];
    }
	[sheet beginCloneRepsitoryToSheetForRepository:repo];
}


- (void) beginCloneRepsitoryToSheetForRepository:(PBGitRepository *)repo
{
	self.repository = repo;
	[self window];

    cloneToSheet = [NSOpenPanel openPanel];
    
	[cloneToSheet setTitle:@"Clone Repository To"];
	[cloneToSheet setPrompt:@"Clone"];
    [self.message setStringValue:[NSString stringWithFormat:@"Select a folder to clone %@ into", [self.repository projectName]]];
    [cloneToSheet setCanSelectHiddenExtension:NO];
    [cloneToSheet setCanChooseFiles:NO];
    [cloneToSheet setCanChooseDirectories:YES];
    [cloneToSheet setAllowsMultipleSelection:NO];
    [cloneToSheet setCanCreateDirectories:YES];
	[cloneToSheet setAccessoryView:cloneToAccessoryView];
    
	[cloneToSheet beginSheetModalForWindow:[self.repository.windowController window]
                         completionHandler:
     ^(NSInteger result) 
     {
         [cloneToSheet orderOut:self];
         
         if (result == NSFileHandlingPanelOKButton) 
         {
             NSString *clonePath = [[cloneToSheet URL] path];
             DLog(@"clone path = %@", clonePath);
             [self.repository cloneRepositoryToPath:clonePath bare:self.isBare];
         }
     }
     ];
}

#pragma mark - IBAction methods
- (IBAction) showHideHiddenFiles:(id)sender
{
    [cloneToSheet setShowsHiddenFiles:[sender state]];
}


@end
