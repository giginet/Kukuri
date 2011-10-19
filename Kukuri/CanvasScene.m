//
//  CanvasScene.m
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "CanvasScene.h"
#import "CanvasLayer.h"

@implementation CanvasScene
- (id)init{
  backgroundColor_ = ccc4(255, 255, 255, 255);
  if( (self=[super init]) ) {
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Kawaz" fontName:@"Marker Felt" fontSize:64];
    CanvasLayer* canvas = [[[CanvasLayer alloc] init] autorelease];
    [label setColor:ccc3(240, 240, 240)];
    CGSize size = [[CCDirector sharedDirector] winSize];
    label.position =  ccp( size.width /2 , size.height/2 );
    [self addChild: label];
    [self addChild:canvas];
  }
	return self;
}

- (void)dealloc{
	[super dealloc];
}
@end
