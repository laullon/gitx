//
//  PBCreateBranchSheet.m
//  GitX
//
//  Created by Nathan Kinsinger on 12/13/09.
//  Copyright 2009 Nathan Kinsinger. All rights reserved.
//

#import "PBCreateBranchSheet.h"
#import "PBGitRepository.h"
#import "PBGitDefaults.h"
#import "PBGitCommit.h"
#import "PBGitRef.h"
#import "PBGitWindowController.h"

@interface PBCreateBranchSheet ()

- (void) beginCreateBranchSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo;
@property (strong) PBGitRepository *repository;
@property (strong) id <PBGitRefish> startRefish;

@end


@implementation PBCreateBranchSheet


@synthesize repository;
@synthesize startRefish;

@synthesize shouldCheckoutBranch;

@synthesize branchNameField;
@synthesize errorMessageField;



#pragma mark -
#pragma mark PBCreateBranchSheet

static PBCreateBranchSheet *sheet;


+ (void) beginCreateBranchSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo
{
    if(!sheet){
        sheet = [[self alloc] initWithWindowNibName:@"PBCreateBranchSheet"];
    }
	[sheet beginCreateBranchSheetAtRefish:ref inRepository:repo];
}


- (void) beginCreateBranchSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo
{
	self.repository = repo;
	self.startRefish = ref;

	[self window]; // loads the window (if it wasn't already)
	[self.errorMessageField setStringValue:@""];
	self.shouldCheckoutBranch = [PBGitDefaults shouldCheckoutBranch];

	// when creating a local branch tracking a remote branch preset the branch name to the name of the remote branch
	if ([self.startRefish refishType] == kGitXRemoteBranchType) {
		NSMutableArray *components = [[[self.startRefish shortName] componentsSeparatedByString:@"/"] mutableCopy];
		if ([components count] > 1) {
			[components removeObjectAtIndex:0];
			NSString *branchName = [components componentsJoinedByString:@"/"];
			[self.branchNameField setStringValue:branchName];
		}
	}

	[NSApp beginSheet:[self window] modalForWindow:[self.repository.windowController window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
}



#pragma mark IBActions

- (IBAction) createBranch:(id)sender
{
	NSString *name = [self.branchNameField stringValue];
	PBGitRef *ref = [PBGitRef refFromString:[kGitXBranchRefPrefix stringByAppendingString:name]];

	if (![self.repository checkRefFormat:[ref ref]]) {
		[self.errorMessageField setStringValue:@"Invalid name!"];
		[self.errorMessageField setHidden:NO];
		return;
	}
    
    NSString *refExistsReturnMessage;
    if([self.repository refExists:ref checkOnRemotesWithoutBranches:NO resultMessage:&refExistsReturnMessage])
    {
        NSError  *error = [NSError errorWithDomain:PBGitRepositoryErrorDomain 
                                              code:0
                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    refExistsReturnMessage, NSLocalizedDescriptionKey,
                                                    @"Select other branchname.", NSLocalizedRecoverySuggestionErrorKey,
                                                    nil]
                           ];
        [[NSAlert alertWithError:error]runModal];
        return;
    }
    else
    {
        if (refExistsReturnMessage)
        {
           int returnButton = [[NSAlert alertWithMessageText:refExistsReturnMessage
                             defaultButton:@"Yes"
                           alternateButton:@"No"
                               otherButton:nil
                 informativeTextWithFormat:@"Still want to create the %@ %@?",[ref refishType],[ref shortName]] runModal];
            
            if (returnButton == NSAlertAlternateReturn)
            {
                return;
            }
        }
    }
	
	[self closeCreateBranchSheet:self];

	[self.repository createBranch:name atRefish:self.startRefish];
	
	[PBGitDefaults setShouldCheckoutBranch:self.shouldCheckoutBranch];

	if (self.shouldCheckoutBranch)
		[self.repository checkoutRefish:ref];
}


- (IBAction) closeCreateBranchSheet:(id)sender
{
	[NSApp endSheet:[self window]];
	[[self window] orderOut:self];
}



@end
