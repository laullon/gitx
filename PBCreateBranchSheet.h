//
//  PBCreateBranchSheet.h
//  GitX
//
//  Created by Nathan Kinsinger on 12/13/09.
//  Copyright 2009 Nathan Kinsinger. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGitRefish.h"


@class PBGitRepository;


@interface PBCreateBranchSheet : NSWindowController 

+ (void) beginCreateBranchSheetAtRefish:(id <PBGitRefish>)ref inRepository:(PBGitRepository *)repo;


- (IBAction) createBranch:(id)sender;
- (IBAction) closeCreateBranchSheet:(id)sender;


@property (assign) BOOL shouldCheckoutBranch;

@property (strong) IBOutlet NSTextField *branchNameField;
@property (strong) IBOutlet NSTextField *errorMessageField;

@end
