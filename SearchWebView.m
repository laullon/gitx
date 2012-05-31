//
//  SearchWebView.m
//  GitX
//
//  Created by German Laullon on 19/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchWebView.h"

@implementation WebView (SearchWebView)

int resultCount=0;
DOMRange *result=nil;

- (int) resultCount {
    return resultCount;
}

- (void)highlightAllOccurencesOfString:(NSString*)str inNode:(DOMNode *)_node
{
    DOMDocument *document=[[self mainFrame] DOMDocument];
    
    DOMNodeList *nodes=[_node childNodes];
    DOMNode *node=[nodes item:0];
    while(node!=nil){
        if([node nodeType]==DOM_TEXT_NODE){
            NSString *block;
            if([[node nodeValue] rangeOfString:str options:NSCaseInsensitiveSearch].location!=NSNotFound){
                NSScanner *scanner=[NSScanner scannerWithString:[node nodeValue]];
                [scanner setCharactersToBeSkipped:nil];
                [scanner setCaseSensitive:NO];
                while([scanner scanUpToString:str intoString:&block]){
                    DOMNode *newNode=[document createTextNode:block];
                    [[node parentNode] appendChild:newNode];
                    
                    while([scanner scanString:str intoString:&block]){
                        DOMElement *span=[document createElement:@"span"];
                        [span setAttribute:@"id" value:[NSString stringWithFormat:@"SWVHL_%d",resultCount++]];
                        [span setAttribute:@"class" value:@"SWVHL"];
                        newNode=[document createTextNode:block];
                        [span appendChild:newNode];
                        [[node parentNode] appendChild:span];
                    }
                }
                [[node parentNode] removeChild:node];
            }
        }else if([node nodeType]==DOM_ELEMENT_NODE){
            [self highlightAllOccurencesOfString:str inNode:node];
        }else{
            DLog(@"--->%@",node);
        }
        node=[node nextSibling];
    }
}

- (void)highlightAllOccurencesOfString:(NSString*)str update:(BOOL)update direction:(BOOL)forward
{   
    if([[[[self mainFrame] DOMDocument] documentElement] isKindOfClass:[DOMHTMLElement class]]){
        DOMHTMLElement *dom=(DOMHTMLElement *)[[[self mainFrame] DOMDocument] documentElement];
        if(update){
            [self removeAllHighlights];
            [self highlightAllOccurencesOfString:str inNode:dom];
        }
        if([self searchFor:str direction:forward caseSensitive:NO wrap:YES]){
            result=[self selectedDOMRange];
        }
    }
}

- (void)search:(NSSearchField *)sender update:(BOOL)update grabFocus:(BOOL)grabFocus direction:(BOOL)forward
{
    NSString *searchString = [sender stringValue];
        
    DLog(@"searchString:%@",searchString);
    
    NSRange searchFieldSelectedRange;
    if (grabFocus) {
        // Back-up the search field's caret position so we can restore it later
        searchFieldSelectedRange = [[sender currentEditor] selectedRange];
    }
    
    if([searchString length]>0){
        [self highlightAllOccurencesOfString:searchString update:update direction:forward];
        
        if (grabFocus) {
            // Bring the search field back in focus and restore its caret position
            [[sender window] makeFirstResponder:sender];
            [[sender currentEditor] setSelectedRange:searchFieldSelectedRange];
        }
        
        if(result!=nil) {
            [self setSelectedDOMRange:result affinity:NSSelectionAffinityDownstream];
        }
    }else{
        [self removeAllHighlights];
    }
}

- (void)removeAllHighlights:(DOMNode *)_node
{
    DOMNode *node=[_node firstChild];
    while(node!=nil){
        if ([node nodeType]==DOM_ELEMENT_NODE) {
            if ([[(DOMElement *)node getAttribute:@"class"] isEqualToString:@"SWVHL"]) {
                DOMNode *txt=[node firstChild];
                DOMNode *parent=[node parentNode];
                [node removeChild:txt];
                [parent insertBefore:txt refChild:node];
                [parent removeChild:node];
                [parent normalize];
                [self removeAllHighlights:parent];
            }else{
                [self removeAllHighlights:node];
            }
        }
        node=[node nextSibling];
    }
}

- (void)removeAllHighlights
{
    resultCount = 0;
    if([[[[self mainFrame] DOMDocument] documentElement] isKindOfClass:[DOMHTMLElement class]]){
        DOMHTMLElement *dom=(DOMHTMLElement *)[[[self mainFrame] DOMDocument] documentElement];
        [self removeAllHighlights:dom];
    }
}

@end
