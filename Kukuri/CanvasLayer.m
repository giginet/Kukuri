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
- (MagicCircle*)createCircle;
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

- (void)cleanup{
  [self unscheduleAllSelectors];
  self.currentCircle = nil;
  [circles_ removeAllObjects];
}

- (void)undo{
  [self unscheduleAllSelectors];
  [circles_ removeLastObject];
  self.currentCircle = nil;
  [self unscheduleAllSelectors];
}

-(void) registerWithTouchDispatcher{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                   priority:0
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
  if(!currentCircle_){
    [self createCircle];
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
  NSMutableArray* list = [NSMutableArray array];
  for(int i = 0; i < 5; ++i){
    [list addObject:[NSString stringWithFormat:@"type%d.png", i]];
  }
  NSString* nearest = [self.currentCircle matchWithTemplates:list];
  NSLog(@"%@", nearest);
  self.currentCircle.active = NO;
  self.currentCircle = nil;
  [self unscheduleAllSelectors];
}

- (MagicCircle*)createCircle{
  self.currentCircle = [MagicCircle circle];
  [circles_ addObject:self.currentCircle];
  [self unscheduleAllSelectors];
  return self.currentCircle;
}

- (void)dealloc{
  [currentCircle_ release];
  [circles_ release];
  [super dealloc];
}

@end
