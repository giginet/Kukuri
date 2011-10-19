//
//  MagicCircle.m
//  Kukuri
//
//  Created by giginet on 11/10/19.
//  Copyright (c) 2011 Kawaz. All rights reserved.
//

#import "MagicCircle.h"

@implementation MagicCircle
@synthesize drawPoints=drawPoints_;

- (id)init{
  if(self = [super init]){
    self.drawPoints = [NSMutableArray array];
  }
  return self;
}

+ (id)circle{
  return [[[MagicCircle alloc] init] autorelease];
}

- (void)addPoint:(CGPoint)point{
  KWVector* vector = [KWVector vectorWithPoint:point];
  [drawPoints_ addObject:vector];
  int count = [drawPoints_ count];
}

- (void)draw{
  int count = [drawPoints_ count];
  if(count > 1){
    for(int i=0;i<count-1;++i){
      KWVector* begin = (KWVector*)[drawPoints_ objectAtIndex:i];
      KWVector* end   = (KWVector*)[drawPoints_ objectAtIndex:i+1];
      ccDrawLine(begin.point, end.point);
    }
  }
}

- (void)match{
}

@end
