//
//  CanvasScene.m
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CanvasScene.h"

@implementation CanvasScene
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Kawaz" fontName:@"Marker Felt" fontSize:64];
    
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
    
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
