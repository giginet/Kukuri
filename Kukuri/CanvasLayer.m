//
//  CanvasLayer.m
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "CanvasLayer.h"

@interface CanvasLayer()
- (void)matching:(id)sender;
@end

@implementation CanvasLayer
@synthesize currentCircle=currentCircle_;

- (id)init{
  if( self = [super init] ){
    circles_ = [[NSMutableArray alloc] init];
    self.currentCircle = nil;
    self.isTouchEnabled = YES;
  }
  return self;
}

- (void)draw{
  for(MagicCircle* circle in circles_){
    [circle draw];
  }
  [super draw];
}

-(void) registerWithTouchDispatcher{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                   priority:0
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  if([circles_ count] == 0){
    self.currentCircle = [MagicCircle circle];
    [circles_ addObject:self.currentCircle];
  }
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
  CGPoint point = [self convertToWorldSpace:[self convertTouchToNodeSpace:touch]];
  [self.currentCircle addPoint:point];
  [self unscheduleAllSelectors];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
  [self schedule:@selector(matching:) interval:2.0];
  [self.currentCircle addLine];
}

- (void)matching:(id)sender{
  NSLog(@"mathing");
  [self.currentCircle match];
  self.currentCircle.active = NO;
  // create new circle
  self.currentCircle = [MagicCircle circle];
  [circles_ addObject:self.currentCircle];
  [self unscheduleAllSelectors];
}

- (void)dealloc{
  [currentCircle_ release];
  [circles_ release];
  [super dealloc];
}

@end
