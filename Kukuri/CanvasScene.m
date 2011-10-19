//
//  CanvasScene.m
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "CanvasScene.h"

@implementation CanvasScene
- (id)init{
  //backgroundColor_ = ccc4(255, 255, 255, 255);
  if( (self=[super init]) ) {
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Kawaz" fontName:@"Marker Felt" fontSize:64];
    [label setColor:ccc3(24, 24, 24)];
    CGSize size = [[CCDirector sharedDirector] winSize];
    label.position =  ccp( size.width /2 , size.height/2 );
    [self addChild: label];
    drawPoints_ = [[NSMutableArray alloc] init];
    self.isTouchEnabled = YES;
	}
	return self;
}

- (void)draw{
  [super draw];
  glColor4f(0.0, 1.0, 0.0, 1.0);
  glLineWidth(4.0f);
  int count = [drawPoints_ count];
  if(count > 1){
    for(int i=0;i<count-1;++i){
      KWVector* begin = (KWVector*)[drawPoints_ objectAtIndex:i];
      KWVector* end   = (KWVector*)[drawPoints_ objectAtIndex:i+1];
      ccDrawLine(begin.point, end.point);
    }
  }
}

-(void) registerWithTouchDispatcher{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                   priority:0
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
  KWVector* point = [KWVector vectorWithPoint:[self convertToWorldSpace:[self convertTouchToNodeSpace:touch]]];
  [drawPoints_ addObject:point];
}

- (void)dealloc{
  [drawPoints_ release];
	[super dealloc];
}
@end
